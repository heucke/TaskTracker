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
  dynamic var dueDate: NSDate = DateHelpers.dateWithNoTime(date: NSDate())
  dynamic var finished = false
}