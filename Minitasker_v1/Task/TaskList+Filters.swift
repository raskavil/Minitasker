import Foundation

extension TaskList {
    
    struct Filters: Codable {
        
        private static let userDefaultsKey = "multitasker.filters"
        
        enum Sort: String, CaseIterable, Codable {
            case priority = "Priority"
            case id = "ID"
            case title = "Title"
            case deadline = "Deadline"
            
            var uiText: String {
                switch self {
                    case .priority: return .localized("filters.sorting.priority")
                    case .id: return .localized("filters.sorting.id")
                    case .title: return .localized("filters.sorting.title")
                    case .deadline: return .localized("filters.sorting.deadline")
                }
            }
        }
        
        var searchText = ""
        var hideDoneTasks = false
        var sort: Sort = .id
        
        func filter(_ tasks: [Task]) -> [Task] {
            
            func performFilter(on tasks: [Task]) -> [Task] {
                var tasks = tasks
                
                if searchText.isEmpty == false {
                    tasks = tasks.filter { $0.title.contains(searchText) }
                }
                
                if hideDoneTasks {
                    tasks = tasks.filter { $0.state != .done}
                }
                
                switch sort {
                    case .priority: tasks = tasks.sorted { $0.priority < $1.priority }
                    case .id:       tasks = tasks.sorted { $0.id < $1.id }
                    case .title:    tasks = tasks.sorted { $0.title < $1.title }
                    case .deadline: tasks = tasks.sorted {
                        switch ($0.deadline, $1.deadline) {
                            case (.some(let lhsDate), .some(let rhsDate)):
                                return lhsDate < rhsDate
                            case (.none, .some):
                                return false
                            case (.some, .none):
                                return true
                            case (.none, .none):
                                return true
                        }
                    }
                        
                }
                
                return tasks
            }
            
            let filteredPinnedTasks = performFilter(on: tasks.filter(\.isPinned))
            let filteredNotPinnedTasks = performFilter(on: tasks.filter { $0.isPinned == false })
            
            return filteredPinnedTasks + filteredNotPinnedTasks
        }
        
        static var userDefaultsValue: Self? {
            UserDefaults.standard.data(forKey: Self.userDefaultsKey)
                .flatMap { try? JSONDecoder().decode(Self.self, from: $0) }
        }
        
        func saveIntoUserDefaults() {
            (try? JSONEncoder().encode(self)).map { UserDefaults.standard.set($0, forKey: Self.userDefaultsKey) }
        }
    }
}
