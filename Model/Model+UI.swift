import SwiftUI

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
            case .low:      return "chevron.down.square.fill"
            case .medium:   return "minus.square.fill"
            case .high:     return "chevron.up.square.fill"
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
