import Foundation
import SQL
import PostgreSQL
import HeliumLogger
import LoggerAPI

class ComputerDAO {
    
    let pgHost = "localhost"
    let pgPort = Int32(5432)
    let pgDBName = "cdbtest"
    let pgUsername = "postgres"
    let pgPassword = ""
    
    var pgConnection: PostgreSQL.Connection!
    
    init() {
        
        do {
            let postgresURL = URL(string: "postgres://\(pgUsername):\(pgPassword)@\(pgHost):\(pgPort)/\(pgDBName)")!
            pgConnection = try PostgreSQL.Connection(info: .init(postgresURL))
            
            try pgConnection.open()
            
            guard pgConnection.internalStatus == PostgreSQL.Connection.InternalStatus.OK else {
                Log.error("Connection refuse : \(pgConnection.internalStatus)")
                return
            }
        } catch {
            Log.error("(\(#function) at \(#line)) - Failed to connect to the server")
        }
        
        Log.info("Connected to PostgreSQL")
    }
    
    func index(onCompletion: @escaping([Computer]?, Error?) -> Void) {
        
        // Warning, need paging
        let query = "SELECT * FROM computer;"
        
        do {
            let result = try self.pgConnection.execute(query)
            
            guard result.status == PostgreSQL.Result.Status.TuplesOK else {
                onCompletion(nil, DatabaseError.ParseError)
                return
            }
            
            var computers = [Computer]()
            
            for i in 0 ..< result.count {
                let id = try Int64(String(describing: result[i].data("computer_id")))
                let name = try String(describing: result[i].data("name"))
                
                computers.append(Computer(id!, withName: name))
            }
            
            onCompletion(computers, nil)
        } catch {
            onCompletion(nil, error)
        }
    }
    
    func get(id: Int64, onCompletion: @escaping(Computer?, Error?) -> Void) {
        
        let query = "SELECT computer_id, name FROM computer WHERE computer_id='\(id)';"
        
        do {
            let result = try self.pgConnection.execute(query)
            
            guard result.status == PostgreSQL.Result.Status.TuplesOK else {
                onCompletion(nil, DatabaseError.ParseError)
                return
            }
            
            guard result.count > 0 else {
                Log.error("No results")
                onCompletion(nil, nil)
                return
            }
            
            let computerId = try Int64(String(describing: result[0].data("computer_id")))
            let name = try String(describing: result[0].data("name"))
            
            onCompletion(Computer(computerId!, withName: name), nil)
        } catch {
            onCompletion(nil, error)
        }
    }
    
    func add(computer: Computer, onCompletion: @escaping(Computer?, Error?) -> Void) {
        
        let query = "INSERT INTO computer (name) VALUES ('\(computer.name)') RETURNING computer_id;"
        
        do {
            let result = try self.pgConnection.execute(query)
            
            guard result.status == PostgreSQL.Result.Status.TuplesOK else {
                onCompletion(nil, DatabaseError.ParseError)
                return
            }
            
            let id = try Int64(String(describing: result[0].data("computer_id")))
            computer.id = id
            onCompletion(computer, nil)
        } catch {
            onCompletion(nil, error)
        }
    }
    
    func update(id: Int64, with computer: Computer, onCompletion: @escaping(Computer?, Error?) -> Void) {
        
        let query = "UPDATE computer SET name = '\(computer.name)' WHERE computer_id = \(id) RETURNING computer_id, name;"
        
        do {
            let result = try self.pgConnection.execute(query)
            
            guard result.status == PostgreSQL.Result.Status.TuplesOK else {
                Log.warning("\(result.status)")
                onCompletion(nil, DatabaseError.ParseError)
                return
            }
            
            let computerId = try Int64(String(describing: result[0].data("computer_id")))
            let name = try String(describing: result[0].data("name"))
            onCompletion(Computer(computerId!, withName: name), nil)
        } catch {
            onCompletion(nil, error)
        }
    }
    
    func delete(id: Int64, onCompletion: @escaping(Error?) -> Void) {
        
        let query = "DELETE FROM computer WHERE computer_id = '\(id)';"
        
        do {
            let result = try self.pgConnection.execute(query)
            
            guard result.status == PostgreSQL.Result.Status.CommandOK else {
                onCompletion(DatabaseError.ParseError)
                return
            }
            
            onCompletion(nil)
            
        } catch {
            onCompletion(error)
        }
    }
}
