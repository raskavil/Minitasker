import Foundation

struct StorableGroup: Storable {
    
    let id: String
    let name: String
    let state: String
    let taskIds: [String]
    let timestamp: Date
    
    init(id: String, name: String, state: String, taskIds: [String]) {
        self.id = id
        self.name = name
        self.state = state
        self.taskIds = taskIds
        self.timestamp = .now
    }
}
