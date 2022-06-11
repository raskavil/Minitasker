import SwiftUI

struct TaskList: View {
    
    @EnvironmentObject var actionService: QuickActionService
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var dataModel = DataModel()
    @State var isWriteViewPresented = false
    @State private var filters: Filters = Filters.userDefaultsValue ?? .init() {
        didSet {
            filters.saveIntoUserDefaults()
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List(filters.filter(dataModel.tasks, pinnedTasks: dataModel.pinnedTasks), id: \.self) { model in
                if let task = dataModel.tasks.first(where: { $0.id == model.id }) {
                    ZStack {
                        TaskCell(model: model)
                        NavigationLink(
                            destination: TaskReadView(
                                model: .init(task: task),
                                taskUpdated: { dataModel.updateTask($0) }
                            )
                        ) { EmptyView() }.opacity(0)
                    }
                        .foregroundColor(.primary)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(
                                role: .destructive,
                                action: ({
                                    withAnimation(.linear) { dataModel.removeTask(task) }
                                })
                            ) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(action: { dataModel.pinnedTasks.toggle(task.id) }) {
                                Label("Pin", systemImage: "pin").tint(.yellow)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: 20, bottom: 4, trailing: 20))
                }
            }
            .searchable(text: $filters.searchText)
            .listStyle(.plain)
            Menu {
                Button(action: { filters.hideDoneTasks.toggle() }) {
                    HStack {
                        Text("Hide Done tasks")
                        if filters.hideDoneTasks {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Menu("Sorting") {
                    ForEach(Filters.Sort.allCases, id: \.rawValue) { sortCase in
                        Button {
                            withAnimation(.linear) { filters.sort = sortCase }
                        } label: {
                            HStack {
                                Text(sortCase.rawValue)
                                if filters.sort == sortCase {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            } label: { 
                Image(systemName: "text.magnifyingglass")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
                    .background(
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .shadow(color: .primary, radius: 3, x: 0, y: 2)
                    )
            }
            .foregroundColor(.primary)
            .padding()
        }
        .navigationBarTitle("Tasks", displayMode: .automatic)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { isWriteViewPresented.toggle() }) { Image(systemName: "plus") }
                    .foregroundColor(.primary)
            }
        }
        .sheet(isPresented: $isWriteViewPresented) {
            NavigationView {
                TaskWriteView(
                    model: .defaultModel(id: (dataModel.tasks.map(\.id).max() ?? 0) + 1),
                    taskUpdated: { self.dataModel.tasks.append($0) }
                )
            }
        }
        .onAppear {
            dataModel.isListVisible = true
        }
        .onDisappear {
            dataModel.isListVisible = false
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                switch actionService.action {
                    case .newTask:
                        if isWriteViewPresented == false {
                            isWriteViewPresented = true
                        }
                    case .iconChange:
                        let iconName = UIApplication.shared.alternateIconName == "whiteIcon" ? nil : "whiteIcon"
                        UIApplication.shared.setAlternateIconName(iconName)
                    case .none:
                        return
                }
                
            }
        }
    }
    
}

extension Array where Element: Equatable {
    
    mutating func toggle(_ element: Element) {
        if let firstIndex = firstIndex(of: element) {
            remove(at: firstIndex)
        } else {
            append(element)
        }
    }
}
