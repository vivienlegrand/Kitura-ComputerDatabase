import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import SwiftyJSON

import ComputerDatabase

HeliumLogger.use()

let router = Router()

// BodyParser middleware allow JSON parsing
router.all("/*", middleware: BodyParser())

let computerController = ComputerController()
router.all("computer", middleware: computerController.router)

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
