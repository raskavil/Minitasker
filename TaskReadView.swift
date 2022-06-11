import SwiftUI

let markdownText = """
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

struct TaskReadView: View {
    
    struct Model {
        let id: Int
        let title: String
        let priority: Task.Priority
        var state: Task.State
        let description: String
        var subtasks: [(name: String, status: Bool)]
        let deadline: Date?
        
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
        
        static var defaultModel: Self {
            .init(
                id: 14, 
                title: "Modify the information",
                priority: .high,
                state: .todo,
                description: markdownText,
                subtasks: [("Hello", false), ("Preparation", true)],
                deadline: .now
            )
        }
    }

    @State var model: Model {
        didSet {
            taskUpdated(model.task)
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
                TaskWriteView(model: .init(task: model.task), taskUpdated: { self.model = .init(task: $0) })
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
                            Button(action: { model.state = state }) {
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
            Text("Deadline:").fontWeight(.bold)
            Text(deadlineString)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private var subtasksView: some View {
        if !model.subtasks.isEmpty {
            Rectangle().frame(height: 1)
            Text("Subtasks:").fontWeight(.bold)
            ForEach(model.subtasks.indices, id: \.self) { index in
                Button(action: { model.subtasks[index].status.toggle() }) {
                    HStack(spacing: 8) {
                        Image(systemName: model.subtasks[index].status ? "star.square" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(model.subtasks[index].name)
                        
                    }
                }
                .foregroundColor(.primary)
            }
        } else {
            EmptyView()
        }
    }
}

struct TaskReadView_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskReadView(model: TaskReadView.Model.defaultModel, taskUpdated: { _ in return })
    }
}

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}
