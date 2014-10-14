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
  let kSecondsInDay: Double = 86400
  
  // MARK: - Properties
  
  @IBOutlet weak var titleBar: UINavigationItem!
  var tasks: RLMArray { // All tasks sorted by dueDate
    get {
      return Task.allObjects().arraySortedByProperty("dueDate", ascending: true)
    }
  }
  var dueDates: [NSDate] { // A set of all of the dueDates past to future
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
  
  // MARK: - Initialization
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftBarButtonItem = self.editButtonItem()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.updateUI() // Update title bar and tableData before view appears
  }
  
  // MARK: - Rows and sections
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.dueDates.count // Each section is a dueDate
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let dateString = Task.getShortDateString(fromDate: self.dueDates[section])
    return Int(tasks.objectsWhere("shortDate == '\(dateString)'").count) // TODO: Match by NSDate and not string representation
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.fancyDueDateMessage(self.dueDates[section]) // More legible due dates
  }
  
  // MARK: - Cells
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.kCellIdentifier, forIndexPath: indexPath) as UITableViewCell
    let task = self.getTasksByDate(dueDates[indexPath.section]).objectAtIndex(UInt(indexPath.row)) as Task
    
    if task.finished == true { // Task title is striked through if finished
      var attributedText = NSMutableAttributedString(string: task.title)
      attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedText.length))
      attributedText.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, attributedText.length))
      cell.textLabel?.attributedText = attributedText
    } else {
      var attributedText = NSMutableAttributedString(string: task.title)
      attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributedText.length))
      cell.textLabel?.attributedText = attributedText
    }
    
    cell.detailTextLabel?.text = task.topic // Right side detail of task cell is the task's topic
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var task = self.getTasksByDate(self.dueDates[indexPath.section]).objectAtIndex(UInt(indexPath.row)) as Task
    
    if task.finished {
      ++UIApplication.sharedApplication().applicationIconBadgeNumber
    } else if !task.finished {
      --UIApplication.sharedApplication().applicationIconBadgeNumber
    }
    
    let realm = RLMRealm.defaultRealm()
    realm.beginWriteTransaction()
    
    task.finished = !task.finished
    
    realm.commitWriteTransaction()
    
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let task = self.getTasksByDate(self.dueDates[indexPath.section]).objectAtIndex(UInt(indexPath.row)) as Task
      let dateCount = self.dueDates.count
      
      if !task.finished { // Decrement app badge if deleting an unfinished task
        --UIApplication.sharedApplication().applicationIconBadgeNumber
      }
      
      let realm = RLMRealm.defaultRealm()
      realm.beginWriteTransaction()
      realm.deleteObject(task)
      realm.commitWriteTransaction()
      
      if self.dueDates.count == dateCount - 1 {
        tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
      } else {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }
    }
  }
  
  // MARK: - Updating UI
  
  func updateUI() {
    self.titleBar.title = "It's \(self.getDayOfWeek(NSDate()))!"
    self.tableView.reloadData()
  }
  
  // MARK: - Helpers
  
  func getTasksByDate(date: NSDate) -> RLMArray {
    let dateString = Task.getShortDateString(fromDate: date)
    return tasks.objectsWhere("shortDate == '\(dateString)'").arraySortedByProperty("topic", ascending: true)
  }
  
  func fancyDueDateMessage(date: NSDate) -> String {
    let days: Int = self.daysFromNow(date)
    if days < -1 {
      return "Due \(days * -1) days ago"
    } else if days == -1 {
      return "Due yesterday"
    } else if days == 0 {
      return "Due today"
    } else if days == 1 {
      return "Due tomorrow"
    } else if days > 1 && days < 7 {
      return "Due on \(self.getDayOfWeek(date))"
    } else if days == 7 {
      return "Due in a week"
    } else {
      return "Due in \(days) days"
    }
  }
  
  func daysFromNow(date: NSDate) -> Int {
    let components = NSCalendar.currentCalendar().components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit, fromDate: NSDate())

    let interval = date.timeIntervalSinceDate(NSCalendar.currentCalendar().dateFromComponents(components)!)
    var days = interval as Double / self.kSecondsInDay // TODO: Learn correct date calculations
    return Int(round(days))
  }
  
  func getDayOfWeek(date: NSDate) -> String {
    let weekday = NSDateFormatter()
    weekday.dateFormat = "EEEE"
    return weekday.stringFromDate(date)
  }
  
  // MARK: - Segue Business
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "EditTask" {
      let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell)
      let task = self.getTasksByDate(self.dueDates[indexPath!.section]).objectAtIndex(UInt(indexPath!.row)) as Task
      let attvc: AddTaskTableViewController = segue.destinationViewController as AddTaskTableViewController
      attvc.taskToEdit = task
      attvc.editMode = true
    }
  }

}
