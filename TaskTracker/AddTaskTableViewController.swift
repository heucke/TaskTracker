//
//  AddTaskTableViewController.swift
//  TaskTracker
//
//  Created by Tyler Heucke on 9/11/14.
//  Copyright (c) 2014 Tyler Heucke. All rights reserved.
//

import UIKit
import Realm

class AddTaskTableViewController: UITableViewController, UITextFieldDelegate, UIAlertViewDelegate {
  
  // MARK: - Outlets
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var topicTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  // MARK: - Properties
  
  var editMode: Bool = false
  var taskToEdit: Task? // Only set if editMode is true
  
  // MARK: - Initialization
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.titleTextField.delegate = self
    self.topicTextField.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.editMode { // Populate info fields
      self.titleTextField.text = self.taskToEdit!.title
      self.topicTextField.text = self.taskToEdit!.topic
      self.datePicker.date = self.taskToEdit!.dueDate
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.titleTextField.becomeFirstResponder() // Keyboard automatically pops up
  }
  
  // MARK: - Button Pressing

  @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
    self.doneAction()
  }
  
  @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
    if self.titleTextField.text.utf16Count > 0 && !self.editMode {
      let alert = UIAlertView(title: "Warning", message: "You have entered a title. Are you sure you would like to cancel?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
      alert.show()
    } else {
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  func doneAction() {
    if self.titleTextField.text.utf16Count == 0 {
      let alert = UIAlertView(title: "Error", message: "You must input a title for the task.", delegate: self, cancelButtonTitle: "OK")
      alert.show()
    } else {
      let realm = RLMRealm.defaultRealm()
      
      if !self.editMode { // Create new task
        let task = Task()
        task.title = self.titleTextField.text
        task.topic = self.topicTextField.text
        task.dueDate = DateHelpers.dateWithNoTime(date: self.datePicker.date)
        
        realm.transactionWithBlock() {
          realm.addObject(task)
        }
      } else if self.editMode { // Edit existing task
        let editedTask = Task()
        
        editedTask.title = self.titleTextField.text
        editedTask.topic = self.topicTextField.text
        editedTask.dueDate = DateHelpers.dateWithNoTime(date: self.datePicker.date)
        editedTask.finished = self.taskToEdit!.finished
        
        realm.transactionWithBlock() {
          realm.deleteObject(self.taskToEdit!)
          realm.addObject(editedTask)
        }
      }
      
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  // MARK: - Helpers
  
  // Dismiss view controller if  user chooses to
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 1 {
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == self.titleTextField { // Move focus to topic text field
      self.topicTextField.becomeFirstResponder()
    } else if textField == self.topicTextField { // Finish adding task
      self.doneAction()
    }
    return true
  }
  
}
