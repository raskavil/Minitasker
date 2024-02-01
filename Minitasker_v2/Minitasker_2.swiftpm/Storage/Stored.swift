import Foundation

struct Stored<Value: Codable> {

    var value: Value {
        get async throws {
            try await Task.detached(priority: .userInitiated) {
                if let data = try FileManager.default.contents(atPath: fileURL.path) {
                    return try JSONDecoder().decode(Value.self, from: data)
                } else {
                    throw NSError()
                }
            }.value
        }
    }
    
    private var fileURL: URL {
        get throws {
            try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .appendingPathComponent(propertyName + String(describing: Value.self) + ".json")
        }
    }
    
    private let propertyName: String
    
    init(propertyName: String) {
        self.propertyName = propertyName
    }
    
    func set(_ value: Value) async throws {
        try JSONEncoder().encode(value).write(to: fileURL)
    }
}
