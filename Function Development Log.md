# Feature development log

---

#### \#2019/4/20

## Finished:

### > Data Model: 

*(details generally follow Physical Table in design report)*

- User (password: allow length from 6 to 15)
- Event (id: only allow length of 8 chars)
- Comment
- Facility (id: only allow length of 10 chars)
- Building
- *Marker (completely different) (only has attr: position) !(waiting)

### > Localization: add Chinese as an optional display language (waiting)

## To Do:

### Input Handling:

1. Username, password, and email (for creating user)
2. Starting place, Facility name (for searching facility)
3. Event name, event place, event date, introImage (for creating event)
4. Comment content (for creating comment)
5. Facility name, location, building (for uploading new facility)
6. Report content (for reporting facility needs maintenance)

### Utility:

1. transform json, excel, pdf, xml or other format to readable data format for app

### Connected to Database:

1. Request to authenticate user
2. Request to download and update all kinds of data
3. Request to upload a facility
4. Request to upload a comment
5. Request to rate user or event
6. Request to access specific kind of data

### User:

1. create an account
2. log in and automatically log in
3. view account info
4. delete account

### Building:

1. update buildings
2. view building info

### Facility:

1. update facilities
2. search facility (compute distance and sort)
3. add new facility
4. view facility info

### Event:

1. update events
2. Create event
3. view event info
4. rate event

### Comment:

1. update comments
2. create comment
3. delete comment
4. rate comment (rate user)

### *Marker:

1. Load local marker
2. allocate markers to new building, facility, or other position



#### \#2019/4/21

1. use CocoaPods to manage dependencies

**Open FindU.xcworkspace to edit the project instead of FindU.xcodeproj (they are both in /FindU/)**

1. use third-party tool —> 3lvis/Sync to parse JSON to core data and back
2. use third-party tool —> OHMySQL