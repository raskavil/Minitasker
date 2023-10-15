import SwiftUI

struct GroupView: View {
    
    let group: Group
    @State var tasks: [Task]
    @State var presentedTask: Task?
    @State var todoTasksExpanded = true
    @State var inProgressTasksExpanded = true
    @State var doneTasksExpanded = false
    
    let taskChanged: (Task) -> [Task]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                title
                taskSection(for: .todo, value: $todoTasksExpanded)
                taskSection(for: .inProgress, value: $inProgressTasksExpanded)
                taskSection(for: .done, value: $doneTasksExpanded)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .sheet(item: $presentedTask) { task in
            NavigationStack {
                TaskReadView(model: task) { tasks = taskChanged($0) }
            }
        }
    }
    
    private var title: some View {
        Text(group.title)
            .lineLimit(3)
            .font(.title.bold())
            .padding(.bottom, 8)
    }
    
    private func taskSection(for state: Task.State, value: Binding<Bool>) -> some View {
        VStack {
            HStack {
                Image(systemName: "chevron.down")
                    .rotationEffect(value.wrappedValue ? .zero : .radians(-.pi))
                Text(state.uiText)
                Spacer()
                Text("\(tasks.filter { $0.state == state }.count)")
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.black, lineWidth: 1)
                    .foregroundStyle(.clear)
            )
            .onTapGesture {
                withAnimation {
                    value.wrappedValue.toggle()
                }
            }
            if value.wrappedValue {
                ForEach(tasks.filter { $0.state == state }, id: \.id) { task in
                    TaskCell(model: task)
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            presentedTask = task
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GroupView(
            group: .init(id: "", title: "Title", tasks: [""], deadline: nil),
            tasks: [.dummy],
            taskChanged: { _ in [] }
        )
    }
}
