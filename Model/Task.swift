import Foundation

struct Task: Hashable, Codable {
    
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
    
    let id: Int
    let priority: Priority
    let title: String
    let state: State
    let description: String
    let subtasks: [Subtask]
    let deadline: Date?
}

struct Subtask: Hashable, Codable {
    
    enum State: String, Hashable, Codable {
        case todo, done
    }
    
    let title: String
    let state: State
}
