import Foundation
import SupportPackage

struct Task: Hashable, Codable, Identifiable {
    
    struct Subtask: Hashable, Codable {
        var title: String
        var done: Bool
    }
    
    enum Priority: String, Hashable, Codable, CaseIterable, Comparable {
        
        static func < (lhs: Task.Priority, rhs: Task.Priority) -> Bool {
            if let lhsIndex = allCases.firstIndex(of: lhs), let rhsIndex = allCases.firstIndex(of: rhs) {
                return lhsIndex > rhsIndex
            }
            return false
        }
        
        case low, medium, high
    }
    
    enum State: String, Hashable, Codable, CaseIterable {
        case todo, inProgress, done
    }
    
    let id: String
    let timestamp: Date
    let priority: Priority
    let title: String
    let state: State
    let description: String
    let subtasks: [Subtask]
    let deadline: Date?
    let isPinned: Bool
    
    init(
        id: String,
        priority: Priority,
        title: String,
        state: State,
        description: String,
        subtasks: [Subtask],
        deadline: Date?,
        isPinned: Bool
    ) {
        self.id = id
        self.timestamp = Date()
        self.priority = priority
        self.title = title
        self.state = state
        self.description = description
        self.subtasks = subtasks
        self.deadline = deadline
        self.isPinned = isPinned
    }
    
    func update<T>(lens: Lens<Self, T>, to value: T) -> Self {
        lens.set(value, self)
    }
}

extension Task {

    static let priority = Lens<Self, Priority>(
        get: \.priority,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: newValue,
                title: task.title,
                state: task.state,
                description: task.description,
                subtasks: task.subtasks,
                deadline: task.deadline,
                isPinned: task.isPinned
            )
        }
    )
    
    static let title = Lens<Self, String>(
        get: \.title,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: task.priority,
                title: newValue,
                state: task.state,
                description: task.description,
                subtasks: task.subtasks,
                deadline: task.deadline,
                isPinned: task.isPinned
            )
        }
    )
    
    static let state = Lens<Self, State>(
        get: \.state,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: task.priority,
                title: task.title,
                state: newValue,
                description: task.description,
                subtasks: task.subtasks,
                deadline: task.deadline,
                isPinned: task.isPinned
            )
        }
    )
    
    static let description = Lens<Self, String>(
        get: \.description,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: task.priority,
                title: task.title,
                state: task.state,
                description: newValue,
                subtasks: task.subtasks,
                deadline: task.deadline,
                isPinned: task.isPinned
            )
        }
    )
    
    static let subtasks = Lens<Self, [Subtask]>(
        get: \.subtasks,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: task.priority,
                title: task.title,
                state: task.state,
                description: task.description,
                subtasks: newValue,
                deadline: task.deadline,
                isPinned: task.isPinned
            )
        }
    )
    
    static let deadline = Lens<Self, Date?>(
        get: \.deadline,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: task.priority,
                title: task.title,
                state: task.state,
                description: task.description,
                subtasks: task.subtasks,
                deadline: newValue,
                isPinned: task.isPinned
            )
        }
    )
    
    static let isPinned = Lens<Self, Bool>(
        get: \.isPinned,
        set: { newValue, task in
            .init(
                id: task.id,
                priority: task.priority,
                title: task.title,
                state: task.state,
                description: task.description,
                subtasks: task.subtasks,
                deadline: task.deadline,
                isPinned: newValue
            )
        }
    )
}

extension Task {
    
    static var dummy: Self {
        .init(
            id: UUID().uuidString,
            priority: .high,
            title: "title",
            state: .inProgress,
            description: "",
            subtasks: [],
            deadline: nil,
            isPinned: false
        )
    }
}
