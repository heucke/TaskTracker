//
//  DateHelpers.swift
//  TaskTracker
//
//  Created by Tyler Heucke on 10/22/14.
//  Copyright (c) 2014 Tyler Heucke. All rights reserved.
//

import Foundation

class DateHelpers {

  // MARK: Set timezone of date to UTC and time to 12:00
  class func dateWithNoTime(date: NSDate = NSDate()) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    let components: NSDateComponents = calendar.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit, fromDate: date)
    calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
    return calendar.dateFromComponents(components)!.dateByAddingTimeInterval(60*60*12) // Add 12 hours
  }

  // MARK: Return a human-readable section header
  class func descriptiveDueDateMessage(date: NSDate) -> String {
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

  // MARK: Return a human-readable weekday - Monday
  class func getDayOfWeek(date: NSDate) -> String {
    let weekday = NSDateFormatter()
    weekday.dateFormat = "EEEE"
    return weekday.stringFromDate(date)
  }
  
  // MARK: Days between today and specified date
  class func daysFromNow(date: NSDate) -> Int {
    let today = self.dateWithNoTime(date: NSDate())
    return self.daysBetween(today, that: date)
  }
  
  // MARK: Number of days between this date and that date
  class func daysBetween(this: NSDate, that: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let result = calendar.components(NSCalendarUnit.DayCalendarUnit, fromDate: this, toDate: that, options: nil).day
    if this.timeIntervalSinceDate(that) > 0 { // that date is before this date
      return result - 1
    }
    return result
  }

}
