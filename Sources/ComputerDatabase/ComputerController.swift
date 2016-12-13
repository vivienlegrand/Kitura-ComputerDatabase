import Foundation
import Kitura
import LoggerAPI
import SwiftyJSON

public final class ComputerController {

    public let router = Router()
    
    let dao = ComputerDAO()

    public init() {
        setupRoutes()
    }

    private func setupRoutes() {
        router.get("/", handler: onIndex)
        router.get("/:id(\\d+)", handler: onGetById)
        router.post("/", handler: onAdd)
        router.post("/:id(\\d+)", handler: onUpdate)
        router.delete("/:id(\\d+)", handler: onDelete)
    }

    private func onIndex(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        dao.index() { computers, error in
            do {
                guard error == nil else {
                    try response.status(.badRequest).end()
                    Log.error(error.debugDescription)
                    return
                }

                let json = JSON(computers!.toDictionary())
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communication error")
            }
        }
    }

    private func onGetById(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        let stringId = request.parameters["id"] ?? ""
        guard let id = Int64(stringId) else {
            Log.warning("Not an id")
            try response.status(.badRequest).end()
            return
        }

        dao.get(id: id) { computer, error in
            do {
                guard error == nil else {
                    try response.status(.badRequest).end()
                    Log.error(error.debugDescription)
                    return
                }

                if let computer = computer {
                    let json = JSON(computer.toDictionary())
                    try response.status(.OK).send(json: json).end()
                } else {
                    try response.status(.notFound).end()
                    Log.error("No computer found")
                    return
                }
            } catch {
                Log.error("Communication error")
            }
        }
    }

    private func onAdd(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        guard let body = request.body else {
            Log.warning("No body found")
            try response.status(.badRequest).end()
            return
        }

        guard let jsonBody = body.asJSON else {
            Log.warning("No JSON found in the body")
            try response.status(.badRequest).end()
            return
        }

        let name = jsonBody["name"].stringValue

        dao.add(computer: Computer(name: name)) { computer, error in
            do {
                guard error == nil else {
                    try response.status(.badRequest).end()
                    Log.error(error.debugDescription)
                    return
                }

                let json = JSON(computer!.toDictionary())
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communication error")
            }
        }
    }

    private func onUpdate(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        let stringId = request.parameters["id"] ?? ""
        guard let id = Int64(stringId) else {
            Log.warning("Not an id")
            try response.status(.badRequest).end()
            return
        }

        guard let body = request.body else {
            Log.warning("No body found")
            try response.status(.badRequest).end()
            return
        }

        guard let jsonBody = body.asJSON else {
            Log.warning("No JSON found in the body")
            try response.status(.badRequest).end()
            return
        }

        let name = jsonBody["name"].stringValue

        dao.update(id: id, with: Computer(id, withName: name)) { computer, error in
            do {
                guard error == nil else {
                    try response.status(.badRequest).end()
                    Log.error(error.debugDescription)
                    return
                }

                if let computer = computer {
                    let json = JSON(computer.toDictionary())
                    try response.status(.OK).send(json: json).end()
                }
            } catch {
                Log.error("Communication error")
            }
        }
    }

    private func onDelete(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        let stringId = request.parameters["id"] ?? ""
        guard let id = Int64(stringId) else {
            Log.warning("Not an id")
            try response.status(.badRequest).end()
            return
        }

        dao.delete(id: id) { error in
            do {
                guard error == nil else {
                    try response.status(.badRequest).end()
                    Log.error(error.debugDescription)
                    return
                }

                try response.status(.OK).end()
            } catch {
                Log.error("Communication error")
            }
        }
    }
}
