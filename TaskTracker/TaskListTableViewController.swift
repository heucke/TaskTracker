//
//  TaskListTableViewController.swift
//  TaskTracker
//
//  Created by Tyler Heucke on 9/11/14.
//  Copyright (c) 2014 Tyler Heucke. All rights reserved.
//

import UIKit
import Foundation
import Realm

class TaskListTableViewController: UITableViewController, UIApplicationDelegate {
  
  // MARK: - Constants
  
  let kCellIdentifier = "TaskCell"
  
  // MARK: - Properties
  
  @IBOutlet weak var titleBar: UINavigationItem!
  var tasks: RLMArray { // All tasks sorted by dueDate
    get {
      return Task.allObjects().arraySortedByProperty("dueDate", ascending: true)
    }
  }
  var dueDates: [NSDate] { // A set of all of the due dates from past to future
    get {
      var dates = [NSDate]()
      for task in tasks {
        if !contains(dates, (task as Task).dueDate) {
          dates.append((task as Task).dueDate)
        }
      }
      return dates
    }
  }
  
  // MARK: - Initialization & Deinitialization
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.updateUI() // Update title bar and tableData before view appears
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontsChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
  }
  
  func setupUI() {
    self.navigationItem.leftBarButtonItem = self.editButtonItem()
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
  }
  
  // MARK: - Fonts
  
  func preferredFontsChanged(notification: NSNotification) {
    self.updateUI()
  }
  
  // MARK: - Rows and sections
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.dueDates.count // Each section is a dueDate
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count = 0
    
    for task in tasks {
      if (task as Task).dueDate == self.dueDates[section] {
        ++count
      }
    }
    
    return count
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return DateHelpers.descriptiveDueDateMessage(self.dueDates[section]) // More legible due dates
  }
  
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    var header = view as UITableViewHeaderFooterView
    header.textLabel.textColor = UIColor.whiteColor()
  }
  
  // MARK: - Cells
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.kCellIdentifier, forIndexPath: indexPath) as UITableViewCell
    let task = self.getTaskByIndexPath(indexPath) as Task
    
    var attributedText = NSMutableAttributedString(string: task.title)
    
    if task.finished == true { // Task title is marked out if finished
      attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedText.length))
      attributedText.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, attributedText.length))
      cell.textLabel.attributedText = attributedText
    } else {
      cell.textLabel.attributedText = attributedText
    }
    
    cell.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    cell.detailTextLabel?.text = task.topic // Right side detail of task cell is the task's topic
    
    cell.tintColor = UIColor.blackColor()
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var task = self.getTaskByIndexPath(indexPath) as Task
    
    let realm = RLMRealm.defaultRealm()
    realm.transactionWithBlock() {
      task.finished = !task.finished
    }
    
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let task = self.getTaskByIndexPath(indexPath) as Task
      let dateCount = self.dueDates.count
      
      let realm = RLMRealm.defaultRealm()
      realm.transactionWithBlock() {
        realm.deleteObject(task)
      }
      
      if self.dueDates.count == dateCount - 1 {
        tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
      } else {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }
    }
  }
  
  // MARK: - Updating UI
  
  func updateUI() {
    self.titleBar.title = "It's \(DateHelpers.getDayOfWeek(NSDate()))!"
    self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    self.tableView.reloadData()
  }
  
  // MARK: - Helpers
  
  func getTaskByIndexPath(indexPath: NSIndexPath) -> Task {
    var tasksByDate: [Task] = []
    
    for task in tasks {
      let currentTask = task as Task
      if currentTask.dueDate == self.dueDates[indexPath.section] {
        tasksByDate.append(currentTask)
      }
    }
    
    return tasksByDate[indexPath.row]
  }
  
  // MARK: - Segue Business
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "EditTask" {
      let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell)
      let task = self.getTaskByIndexPath(indexPath!)
      let attvc: AddTaskTableViewController = segue.destinationViewController as AddTaskTableViewController
      attvc.editMode = true
      attvc.taskToEdit = task
    }
  }

}
