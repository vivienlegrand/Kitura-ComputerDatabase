import Foundation

typealias JSONDictionary = [String: Any]

protocol DictionaryConvertible {
    func toDictionary() -> JSONDictionary
}

extension Computer: DictionaryConvertible {

    func toDictionary() -> JSONDictionary {
        var result = JSONDictionary()

        result["id"] = self.id
        result["name"] = self.name

        return result
    }
}

extension Array where Element: DictionaryConvertible {

    func toDictionary() -> [JSONDictionary] {
        return self.map {
            $0.toDictionary()
        }
    }
}
