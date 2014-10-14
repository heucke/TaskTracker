//
//  Task.swift
//  TaskTracker
//
//  Created by Tyler Heucke on 9/11/14.
//  Copyright (c) 2014 Tyler Heucke. All rights reserved.
//

import Foundation
import Realm

class Task: RLMObject {
  
  dynamic var title = ""
  dynamic var topic = ""
  dynamic var dueDate: NSDate = NSDate(timeIntervalSince1970: 0) {
    didSet {
      self.shortDate = Task.getShortDateString(fromDate: self.dueDate)
    }
  }
  dynamic var shortDate = Task.getShortDateString(fromDate: NSDate())
  dynamic var finished = false
  
  class func getShortDateString(fromDate date: NSDate) -> String {
    if date == NSDate(timeIntervalSince1970: 0) {
      return "No due date"
    } else {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MM/dd/yy"
      return formatter.stringFromDate(date)
    }
  }
  
}