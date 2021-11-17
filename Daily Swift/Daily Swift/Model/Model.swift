import Foundation
import UIKit
import FSCalendar

struct Category: Hashable, Codable {
    var color: CodableColor
    var title: String
    static let basicCategory: Category = Category(color: .init(color: .systemBlue), title: "기본 카테고리")
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

struct Todo: Hashable, Codable {
    var todoTitle: String = ""
    var category: Category = Category.basicCategory
    var startDay: Date = Date()
    var endDay: Date = Date()
    var alarm: Alarm? = nil
    var isGoal: Bool = false
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

struct Alarm: Hashable, Codable {
    var isOn: Bool = false
    var hour: Int = 00
    var minute: Int = 00
    var _idString: [String] = []
    var idStrings: [String] {
        get {
            return self._idString
        } set(newValue) {
            self._idString = newValue
        }
    }
}

struct CodableColor: Hashable {
    let color: UIColor
}

extension CodableColor: Encodable {
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        guard let color = UIColor(coder: nsCoder) else {
            struct UnexpectedlyFoundNilError: Error {}
            throw UnexpectedlyFoundNilError()
        }
        self.color = color
    }
}
