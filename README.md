# Kitura-ComputerDatabase
Sample backend using [Kitura](https://github.com/IBM-Swift/Kitura) 1.3 and [Zewo's PostgreSQL adapter](https://github.com/Zewo/PostgreSQL).  
The project is an updated and simple version of the sample made by IBM : [TodoList-PostgreSQL](https://github.com/IBM-Swift/TodoList-PostgreSQL)

---
## Requirements
* Swift 3+
* PostgreSQL 9+

---
## Installation
For launch the project, run 
```bash
swift build -Xcc -I/usr/local/include -Xlinker -L/usr/local/lib/
```

For generate an XCode project :
```bash
swift package generate-xcodeproj -Xcc -I/usr/local/include -Xlinker -L/usr/local/lib/ -Xswiftc -I/usr/local/include
```

Create a `cdbtest` database with the `postgres` user, or update the configuration in `ComputerDAO.swift`. After you can create a `computer` table :
```sql
CREATE TABLE computer
(
    computer_id     bigserial       PRIMARY KEY,
    name            varchar(128)    NOT NULL
);
```

---
## Launch
```bash
swift build -Xcc -I/usr/local/include -Xlinker -L/usr/local/lib/ 
.build/debug/Deploy
```

---
## APIs

* Index  
`GET` with <localhost:8090/computer>
* Get by Id  
`GET` with <localhost:8090/computer/:id>
* Add  
`POST` with <localhost:8090/computer>
* Update  
`POST` with <localhost:8090/computer/:id>
* Delete  
`DELETE` with <localhost:8090/computer/:id>

---
## More info

This project does not include Security capabilities of Kitura. For more info about Kitura, visite <http://www.kitura.io/en/resources/tutorials.html>.
