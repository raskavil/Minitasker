import SwiftUI

struct TaskCell: View {
    
    @State var model: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                if model.isPinned {
                    Image(systemName: "pin")
                }
                Text(model.title)
                    .lineLimit(2)
                    .font(.headline)
            }
            HStack(spacing: 8) {
                Image(systemName: model.priority.icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                Text(model.state.uiText)
            }
            if let deadlineText = model.deadlineText {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .resizable()
                        .frame(width: 24, height: 20)
                    Text(deadlineText)
                }
            }
            if let subtasks = model.subtaskCount {
                HStack {
                    Image(systemName: "list.star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(2)
                    Text("\(subtasks.done) / \(subtasks.total)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.primary, lineWidth: 1))
    }
}

extension Task {

    var subtaskCount: (total: Int, done: Int)? {
        if !subtasks.isEmpty {
            return (subtasks.count, subtasks.filter(\.done).count)
        } else {
            return nil
        }
    }
    
    var deadlineText: String? {
        if let deadline = deadline, let daysRemaining = Calendar.current.numberOfDaysBetween(.now, and: deadline) {
            if daysRemaining >= 7 {
                return deadline.string
            } else if daysRemaining < 0 {
                return .localized("task_list.past_deadline")
            } else {
                return String(format: .localized("task_list.days_remaining"), daysRemaining)
            }
        } else {
            return nil
        }
    }
    
}
