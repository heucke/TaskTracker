//
//  TaskTrackerTests.swift
//  TaskTrackerTests
//
//  Created by Tyler Heucke on 9/11/14.
//  Copyright (c) 2014 Tyler Heucke. All rights reserved.
//

import UIKit
import XCTest

class TaskTrackerTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // MARK: Testing Task
  
  func testTask() {
    let task = Task()
    
    XCTAssertEqual(task.title, "", "Title not properly initialized")
    XCTAssertEqual(task.topic, "", "Topic not properly initialized")
    XCTAssertEqual(task.dueDate, DateHelpers.dateWithNoTime(date: NSDate()), "Due date not properly initialized")
    XCTAssertFalse(task.finished, "Finished not properly initialized")
  }
  
  // MARK: Testing DateHelpers
  
  func testDateWithNoTime() {
    let beginning = NSDate(timeIntervalSince1970: 8*60*60) // Offset +8 hours to GMT
    
    XCTAssertEqual(DateHelpers.dateWithNoTime(date: beginning), NSDate(timeIntervalSince1970: 12*60*60), "Time should be 12:00")
  }
  
  func testDaysBetween() {
    let today = DateHelpers.dateWithNoTime(date: NSDate())
    let tomorrow = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: 24*60*61))
    let yesterday = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: -24*60*61))
    
    XCTAssertEqual(DateHelpers.daysBetween(today, that: today), 0, "Today test failed")
    XCTAssertEqual(DateHelpers.daysBetween(today, that: yesterday), -1, "Yesterday test failed")
    XCTAssertEqual(DateHelpers.daysBetween(today, that: tomorrow), 1, "Tomorrow test failed")
  }
  
  func testDaysFromNow() {
    let today = DateHelpers.dateWithNoTime(date: NSDate())
    let tomorrow = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: 24*60*61))
    let yesterday = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: -24*60*61))
    
    XCTAssertEqual(DateHelpers.daysFromNow(today), 0, "Today test failed")
    XCTAssertEqual(DateHelpers.daysFromNow(yesterday), -1, "Yesterday test failed")
    XCTAssertEqual(DateHelpers.daysFromNow(tomorrow), 1, "Tomorrow test failed")
  }
  
  func testGetDayOfWeek() {
    let beginning = NSDate(timeIntervalSince1970: 8*60*60) // Offset +8 hours to GMT
    
    XCTAssertEqual(DateHelpers.getDayOfWeek(beginning), "Thursday", "00:00 on 1/1/1970 was a Thursday")
  }

  func testDescriptiveDueDateMessage() {
    let twoDaysAgo = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: -2*24*60*61))
    let yesterday = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: -24*60*61))
    let today = DateHelpers.dateWithNoTime(date: NSDate())
    let tomorrow = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: 24*60*61))
    let aWeek = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: 7*24*60*61))
    let tenDays = DateHelpers.dateWithNoTime(date: NSDate(timeIntervalSinceNow: 10*24*60*61))
    
    XCTAssertEqual(DateHelpers.descriptiveDueDateMessage(twoDaysAgo), "Due 2 days ago", "Today test failed")
    XCTAssertEqual(DateHelpers.descriptiveDueDateMessage(yesterday), "Due yesterday", "Today test failed")
    XCTAssertEqual(DateHelpers.descriptiveDueDateMessage(today), "Due today", "Today test failed")
    XCTAssertEqual(DateHelpers.descriptiveDueDateMessage(tomorrow), "Due tomorrow", "Today test failed")
    XCTAssertEqual(DateHelpers.descriptiveDueDateMessage(aWeek), "Due in a week", "Today test failed")
    XCTAssertEqual(DateHelpers.descriptiveDueDateMessage(tenDays), "Due in 10 days", "Today test failed")
  }
  
  // MARK: Testing AddTaskTableViewController
  
  func testAddTaskTableViewController() {
    let attvc = AddTaskTableViewController()
    
    XCTAssert(attvc.taskToEdit == nil, "taskToEdit should be nil")
  }
}
