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
  
  var taskToEdit: Task? // Will be nil if making a new task
  
  // MARK: - Initialization
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.titleTextField.delegate = self
    self.topicTextField.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let task = self.taskToEdit { // Populate info fields
      self.titleTextField.text = task.title
      self.topicTextField.text = task.topic
      self.datePicker.date = task.dueDate
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
    if self.titleTextField.text.utf16Count > 0 && self.titleTextField.text != self.taskToEdit?.title {
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
      if let task = taskToEdit {
        realm.transactionWithBlock() {
          task.title = self.titleTextField.text
          task.topic = self.topicTextField.text
          task.dueDate = DateHelpers.dateWithNoTime(date: self.datePicker.date)
        }
      } else {
        var task = Task()
        task.title = self.titleTextField.text
        task.topic = self.topicTextField.text
        task.dueDate = DateHelpers.dateWithNoTime(date: self.datePicker.date)
        realm.transactionWithBlock() {
          realm.addObject(task)
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
