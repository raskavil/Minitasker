import Foundation

struct StorableTask: Storable {
    
    struct Subtask: Codable {
        let name: String
        let state: String
    }
    
    let id: String
    let name: String
    let state: String
    let description: String
    let subtasks: [Subtask]
    let timestamp: Date
    
    init(id: String, name: String, state: String, description: String, subtasks: [Subtask]) {
        self.id = id
        self.name = name
        self.state = state
        self.description = description
        self.subtasks = subtasks
        self.timestamp = .now
    }
}
