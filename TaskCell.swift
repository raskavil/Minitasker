import SwiftUI

struct TaskCell: View {
    
    struct Model: Identifiable, Hashable {
        let id: Int
        let isPinned: Bool
        let title: String
        let state: String
        let icon: String
        let deadlineText: String?
        let totalSubtasks: Int?
        let doneSubtasks: Int?
    }
    
    @State var model: Model
    
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
                Image(systemName: model.icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                Text(model.state)
            }
            if let deadlineText = model.deadlineText {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .resizable()
                        .frame(width: 24, height: 20)
                    Text(deadlineText)
                }
            }
            if let totalSubtasks = model.totalSubtasks, let doneSubtasks = model.doneSubtasks, totalSubtasks > 0 {
                HStack {
                    Image(systemName: "list.star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(2)
                    Text("\(doneSubtasks) / \(totalSubtasks)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.primary, lineWidth: 1))
    }
}


