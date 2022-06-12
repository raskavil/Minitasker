import SwiftUI

extension TaskCell.Model {
    init(task: Task, isPinned: Bool) {
        
        let subtasks: (total: Int, done: Int)?
        if !task.subtasks.isEmpty {
            subtasks = (task.subtasks.count, task.subtasks.filter { $0.state == .done }.count)
        } else {
            subtasks = nil
        }
        
        let deadlineText: String?
        if let deadline = task.deadline, let daysRemaining = Calendar.current.numberOfDaysBetween(.now, and: deadline) {
            if daysRemaining >= 7 {
                deadlineText = deadline.string
            } else if daysRemaining < 0 {
                deadlineText = .localized("task_list.past_deadline")
            } else {
                deadlineText = String(format: .localized("task_list.days_remaining"), daysRemaining)
            }
        } else {
            deadlineText = nil
        }
        
        self.init(
            id: task.id,
            isPinned: isPinned,
            title: task.title, 
            state: task.state.uiText,
            icon: task.priority.icon,
            deadlineText: deadlineText,
            totalSubtasks: subtasks?.total,
            doneSubtasks: subtasks?.done
        )
    }
}

extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int? {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
                
        return numberOfDays.day
    }
}

extension Task.Priority {
    
    var uiText: String {
        switch self {
            case .low:      return .localized("task.priority.low")
            case .medium:   return .localized("task.priority.medium")
            case .high:     return .localized("task.priority.high")
        }
    }
    
    var icon: String {
        switch self {
            case .low: return "chevron.down.square.fill"
            case .medium: return "minus.square.fill"
            case .high: return "chevron.up.square.fill"
        }
    }
    
}

extension Task.State {
    
    var uiText: String {
        switch self {
            case .todo:         return .localized("task.state.todo")
            case .inProgress:   return .localized("task.state.in_progress")
            case .done:         return .localized("task.state.done")
        }
    }
}

extension TaskReadView.Model {
    
    var task: Task {
        .init(
            id: id,
            priority: priority,
            title: title,
            state: state,
            description: description,
            subtasks: subtasks.map { .init(title: $0.name, state: $0.status ? .done : .todo) },
            deadline: deadline
        )
    }
    
    init(task: Task) {
        self.init(
            id: task.id,
            title: task.title,
            priority: task.priority,
            state: task.state,
            description: task.description,
            subtasks: task.subtasks.map { ($0.title, $0.state == .done) },
            deadline: task.deadline
        )
    }
}

extension TaskWriteView.Model {
    
    var task: Task {
        .init(
            id: id,
            priority: priority,
            title: title,
            state: state,
            description: description,
            subtasks: subtasks.map { .init(title: $0.name, state: $0.status ? .done : .todo) },
            deadline: isDateActivated ? deadline : nil
        )
    }
    
    init(task: Task) {
        self.init(
            id: task.id,
            title: task.title,
            priority: task.priority,
            state: task.state,
            description: task.description,
            subtasks: task.subtasks.map { ($0.title, $0.state == .done) },
            deadline: task.deadline ?? Calendar.current.startOfDay(for: .now),
            isDateActivated: task.deadline != nil
        )
    }
    
}
