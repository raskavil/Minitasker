import SwiftUI

struct TaskReadView: View {

    @State var model: Task {
        didSet {
            taskUpdated(model)
        }
    }
    @State var isWriteViewPresented: Bool = false
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
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { isWriteViewPresented.toggle() }) {
                    Image(systemName: "pencil.circle")
                }.foregroundColor(.primary)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $isWriteViewPresented) {
            NavigationView {
                TaskWriteView(model: .init(task: model), taskUpdated: { self.model = $0 })
            }
        }
    }
    
    
    @ViewBuilder private var titleView: some View {
        Text(model.title)
            .font(.title.bold())
    }
    
    @ViewBuilder private var stateView: some View {
        HStack(alignment: .bottom) {
            Image(systemName: model.priority.icon)
                .resizable()
                .frame(width: 24, height: 24)
            Menu(
                content: {
                    VStack {
                        ForEach(Task.State.allCases, id: \.rawValue) { state in
                            Button(action: { model = model.update(lens: Task.state, to: state) }) {
                                HStack {
                                    Text(state.uiText)
                                    if state == model.state {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                },
                label: { Text(model.state.uiText).fontWeight(.medium) }
            )
            .foregroundColor(.primary)
            .transaction { $0.animation = nil }
        }
    }
    
    @ViewBuilder private var textView: some View {
        if model.attributedDescription.description.isEmpty == false {
            Rectangle().frame(height: 1)
            Text(model.attributedDescription)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private var deadlineView: some View {
        if let deadlineString = model.deadline?.string {
            Rectangle().frame(height: 1)
            Text(String.localized("task_read_view.deadline")).fontWeight(.bold)
            Text(deadlineString)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private var subtasksView: some View {
        if !model.subtasks.isEmpty {
            Rectangle().frame(height: 1)
            Text(String.localized("task_read_view.subtasks")).fontWeight(.bold)
            ForEach(model.subtasks.indices, id: \.self) { index in
                let subtask = model.subtasks[index]
                Button(action: {
                    var newSubtasks = model.subtasks
                    newSubtasks[index].done.toggle()
                    model = model.update(lens: Task.subtasks, to: newSubtasks)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: subtask.done ? "star.square" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(subtask.title)
                        
                    }
                }
                .foregroundColor(.primary)
            }
        } else {
            EmptyView()
        }
    }
}

extension Task {
    var attributedDescription: AttributedString {
        do {
            return try AttributedString(
                markdown: description,
                options: .init(
                    allowsExtendedAttributes: false,
                    interpretedSyntax: .inlineOnly,
                    failurePolicy: .returnPartiallyParsedIfPossible
                )
            )
        } catch {
            return AttributedString(description)
        }
    }
}

struct TaskReadView_Previews: PreviewProvider {
    
    static let markdownText = """
    Because the mentiones piece of information has been *lost*, we need to introduce several **important** options. Namely:
    - Check the servers for missing info
    - Improve the security to prevent future attacks
    - Investigate information to prevent
    # Hello
    1. First item
    2. Second item
    3. Third item
    4. Fourth item
    All these things have to be done prior to any future user data handling.

    For more information visit [apple.com](apple.com)!
    """

    static var previews: some View {
        TaskReadView(model: .dummy, taskUpdated: { _ in return })
    }
}

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}
