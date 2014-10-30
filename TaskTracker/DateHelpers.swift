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
    calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
    let components: NSDateComponents = calendar.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit, fromDate: date)
    let dateWithNoTime = calendar.dateFromComponents(components)!
    return dateWithNoTime.dateByAddingTimeInterval(60.0 * 60.0 * 12.0) // Set time to 12:00
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

  // MARK: Return a human-readable weekday
  class func getDayOfWeek(date: NSDate) -> String {
    let weekday = NSDateFormatter()
    weekday.dateFormat = "EEEE"
    return weekday.stringFromDate(date)
  }
  
  // MARK: Days between today and specified date
  class func daysFromNow(date: NSDate) -> Int {
    return self.daysBetween(NSDate(), that: date)
  }
  
  // MARK: Number of days between this date and that date
  class func daysBetween(this: NSDate, that: NSDate) -> Int {
    let unitFlags = NSCalendarUnit.DayCalendarUnit
    let calendar = NSCalendar.currentCalendar()
    if self.dateWithNoTime(date: this).isEqualToDate(self.dateWithNoTime(date: that)) {
      return 0 // Same day
    } else if that.timeIntervalSinceNow < 0 {
      let components = calendar.components(unitFlags, fromDate: this, toDate: that, options: nil)
      return components.day // Past
    } else {
      let components = calendar.components(unitFlags, fromDate: this, toDate: that, options: nil)
      return components.day + 1 // Future
    }
  }

}
