# TaskTracker 2.0.0

An app through which I learned Xcode, Swift, Cocoa, and RealmDB. I designed TaskTracker to be simple and easy to understand, while still containing enough data to be useful for a university student. I use it every day of my life. If you allow it, the app will display a badge numbering each task due by a certain number of days in the future. This number can be customised in the Settings app, and defaults to one day in the future (tomorrow).

Tasks in TaskTracker are simple. Each task has a mandatory title and due date, plus an optional topic. Tasks are sorted by due date in the task list. Every aspect of a task can be edited. Tasks can be swiped on to delete, or tapped on to mark finished.

If you allow it, TaskTracker will display an app badge that corresponds to the number of unfinished tasks due by tomorrow. This threshold will be customizable in the next update.

## Version History

- 2.0.0
	- NOW USING SEMANTIC VERSIONING
	- Topics are now lowercase to improve readability
- 1.3.3
	- Change threshold for app badge (defaults to 1, or tomorrrow)
- 1.3.2
	- Fix tasks due in past being off one day
	- Add badge for unfinished tasks due by tomorrow
- 1.3.1
   - Fixed issue where cursor was invisible
   - Changed styling of add task view
- 1.3.0
   - Change main color of app to a nice blue (from Google's material design)
- 1.2.1
   - Fix bug where time zone differences can move a selected date forwards by one day
- 1.2.0
   - Fix bug where intervals were off by a day
   - Use UTC for universal NSDate storage
- 1.1.1
   - Move NSDate helper functions to separate file
   - Compare dates by NSDate
- 1.1.0
   - Respect accesibility text size setting
- 1.0.1
   - Editing tasks when Edit button is tapped
   - Display delete button in Edit mode
- 1.0
   - Edit tasks with info button
   - Display unfinished tasks in app badge

