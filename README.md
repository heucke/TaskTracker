TaskTracker Verison 1.1.5
==============

An app through which I learned Xcode, Swift, Cocoa, and RealmDB. I designed TaskTracker to be simple and easy to understand, while still containing enough data to be useful for a university student. I use it every day of my life.

Tasks in TaskTracker are simple. Each task has a mandatory title and due date, plus an optional topic. Tasks are sorted by due date in the task list. Every aspect of a task can be edited. Tasks can be swiped on to delete, or tapped on to mark finished.

If you allow it, TaskTracker will display an app badge that corresponds to the number of unfinished tasks due by tomorrow. This threshold will be customizable in the next update.

Version History
===============

- 1.1.5
	- Change threshold for app badge (defaults to 1, or tomorrrow)
- 1.1.4
	- Remove superfluous boolean when editing tasks
	- Fix tasks due in past being off one day
	- Add badge for unfinished tasks due by tomorrow
- 1.1.3
    - Fixed issue where cursor was invisible
    - Changed styling of add task view
- 1.1.2
    - Change main color of app to a nice blue (from Google's material design)
- 1.1.1
    - Fix bug where time zone differences can move a selected date forwards by one day
- 1.1.0
    - Fix bug where intervals were off by a day
    - Use UTC for universal NSDate storage
- 1.0.3
    - Move NSDate helper functions to separate file
    - Compare dates by NSDate
- 1.0.2
    - Respect accesibility text size setting
- 1.0.1
    - Editing tasks when Edit button is tapped
    - Display delete button in Edit mode
- 1.0
    - Edit tasks with info button
    - Display unfinished tasks in app badge

