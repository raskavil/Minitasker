import Foundation
import SupportPackage

struct Group: Hashable, Codable {

    let id: String
    let timestamp: Date
    let title: String
    let tasks: [String]
    let deadline: Date?
    
    init(id: String, title: String, tasks: [String], deadline: Date?) {
        self.id = id
        self.timestamp = Date()
        self.title = title
        self.tasks = tasks
        self.deadline = deadline
    }
}

extension Group {
    
    static let title = Lens<Self, String>(
        get: \.title,
        set: { .init(id: $1.id, title: $0, tasks: $1.tasks, deadline: $1.deadline) }
    )
    
    static let tasks = Lens<Self, [String]>(
        get: \.tasks,
        set: { .init(id: $1.id, title: $1.title, tasks: $0, deadline: $1.deadline) }
    )
    
    static let deadline = Lens<Self, Date?>(
        get: \.deadline,
        set: { .init(id: $1.id, title: $1.title, tasks: $1.tasks, deadline: $0) }
    )
}
