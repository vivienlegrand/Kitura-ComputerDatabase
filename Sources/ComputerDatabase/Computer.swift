import Foundation

class Computer {

    var id: Int64?
    let name: String

    init(name: String) {
        self.name = name
    }

    init(_ id: Int64, withName name: String) {
        self.id = id
        self.name = name
    }
}
