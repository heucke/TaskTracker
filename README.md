TaskTracker V1.22
===========

An app through which I learned Xcode, Swift, Cocoa, and RealmDB. I designed TaskTracker to be simple and easy to understand, while still containing enough data to be useful for a university student. I use it every day of my life.

Usage
=====

- Add tasks using the add button in the navigation bar.
- Mark tasks complete by tapping on their names.
- Delete tasks by swiping and tapping delete.
- Edit tasks by tapping on the information button.
- Titles and due dates are necessary, but topics are not.

Version History
===============

- 1.00
    + Tasks can be edited using the information button
    + This will be streamlined in a future update
    + Aplication icon badge now displays total number of unfinished tasks
- 1.10
    + App now asks for permission to display badges
    + Editing tasks is now enabled when Edit button is tapped
    + Edit button also displays deletion circles for each task
- 1.11
    + Task list now respects accesibility text size setting
- 1.20
    + Moved NSDate helper function to separate file
    + All date comparison is now done though NSDate, as opposed to string representation comparison
- 1.21
    + Interval between two dates is now properly calculated
    + DatePicker's time zone is now properly set
- 1.22
    + Fixed issue where time zone differences could move a selected date forwards by one day
