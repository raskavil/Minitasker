import SwiftUI

struct GroupList: View {
    
    @State var groups: [Group]
    
    var body: some View {
        List(groups) { model in
            ZStack {
                GroupCell(name: model.title, tasks: (1, 3, 5))
                NavigationLink(
                    destination: GroupView(
                        group: model,
                        tasks: [],
                        taskChanged: { _ in [] }
                    )
                ) { EmptyView() }.opacity(0)
            }
            .foregroundColor(.primary)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(
                    role: .destructive,
                    action: ({
                        withAnimation(.linear) { }//dataModel.removeTask(task) }
                    })
                ) {
                    Label(String.localized("task_list.delete"), systemImage: "trash")
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button(action: {
                    // dataModel.updateTask(model.update(lens: Task.isPinned, to: !model.isPinned))
                }) {
                    Label(String.localized("task_list.pin"), systemImage: "pin").tint(.yellow)
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 4, leading: 20, bottom: 4, trailing: 20))
        }
        .listStyle(.plain)
        .navigationBarTitle(String.localized("group_list.title"), displayMode: .automatic)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { }) { Image(systemName: "plus") }
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    GroupList(groups: [
        .init(id: "s", title: "Group1", tasks: ["id, id"], deadline: Date()),
        .init(id: "sd", title: "Group2", tasks: ["id, id"], deadline: Date()),
        .init(id: "sdd", title: "Group3", tasks: ["id, id"], deadline: Date()),
        .init(id: "sdd", title: "Group4", tasks: ["id, id"], deadline: Date())
    ])
}
