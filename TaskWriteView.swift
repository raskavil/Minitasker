import SwiftUI

struct TaskWriteView: View {
    
    struct Model {
       
        let id: Int
        var title: String
        var priority: Task.Priority
        let state: Task.State
        var description: String
        var subtasks: [(name: String, status: Bool)]
        var deadline: Date
        var isDateActivated: Bool
        
        static let defaultText = """
        Here you can put description of your task
        Text formatting examples:
        - *Italic*
        - **Bold**
        - ***Bold Italic***
        - [Link name](https://example.com)
        """
        
        static func defaultModel(id: Int) -> Self {
            .init(
                id: id,
                title: "New task",
                priority: .high,
                state: .todo,
                description: Self.defaultText,
                subtasks: [("Subtask", false)],
                deadline: .now,
                isDateActivated: false
            )
        }
    }

    @Environment(\.dismiss) private var dismiss
    @State private(set) var model: Model
    let taskUpdated: (Task) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                titleView
                stateView
                textView
                deadlineView
                subtasksView
            }.padding(10)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(role: .cancel, action: { dismiss() }, label: { Text("Cancel") })
                    .foregroundColor(.primary)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { taskUpdated(model.task); dismiss() }, label: { Text("Done").bold() })
                    .foregroundColor(.primary)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    
    @ViewBuilder private var titleView: some View {
        TextField("", text: $model.title).font(.title.bold())
    }
    
    @ViewBuilder private var stateView: some View {
        HStack(alignment: .bottom) {
            Menu(
                content: {
                    VStack {
                        ForEach(Task.Priority.allCases, id: \.rawValue) { priority in
                            Button(action: { model.priority = priority }) {
                                HStack {
                                    Text(priority.uiText)
                                    if priority == model.priority {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                },
                label: {
                    Image(systemName: model.priority.icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            )
            .foregroundColor(.primary)            
            Text(model.state.uiText).fontWeight(.medium).foregroundColor(.primary)
        }
    }
    
    @ViewBuilder private var textView: some View {
        Rectangle().frame(height: 1)
        ZStack {
            TextEditor(text: $model.description)
            Text(model.description).opacity(0).padding(.all, 8)
        }
    }
    
    @ViewBuilder private var deadlineView: some View {
        Rectangle().frame(height: 1)
        HStack {
            Text("Deadline:").fontWeight(.bold)
            Spacer()
            Toggle("", isOn: $model.isDateActivated).tint(.primary)
        }
        DatePicker(selection: $model.deadline, displayedComponents: [.date]) { Rectangle().frame(width: 0, height: 0) }
            .disabled(model.isDateActivated == false)
    }
    
    @ViewBuilder private var subtasksView: some View {
        Rectangle().frame(height: 1)
        HStack {
            Text("Subtasks:").fontWeight(.bold)
            Spacer()
            Button(action: { model.subtasks.append((("New subtask"), false)) }) { Image(systemName: "plus") }
                .foregroundColor(.primary)
        }
        ForEach(model.subtasks.indices, id: \.self) { index in
            HStack {
                TextField("", text: $model.subtasks[index].name).foregroundColor(.primary).tint(.primary)
                Spacer()
                Button(action: { model.subtasks.remove(at: index)}) { Image(systemName: "trash") }
                    .foregroundColor(.primary)
            }
        }
    }
}

struct TaskWriteView_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskWriteView(model: TaskWriteView.Model.defaultModel(id: 14), taskUpdated: { _ in return })
    }
}
