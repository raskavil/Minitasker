import Foundation
import Combine

class DataModel: ObservableObject {
    
    private static let pinnedTasksKey = "minitasker.pinnedTasks"
    
    var isListVisible: Bool = false {
        didSet {
            if isListVisible {
                objectWillChange.send()
            }
        }
    }
    
    var tasks: [Task] {
        didSet {
            do {
                if isListVisible {
                    objectWillChange.send()
                }
                try saveTasksToFile(tasks)
            } catch {
                print("Saving tasks failed!")
            }
        }
    }
    
    @Published var pinnedTasks: [Int] {
        didSet {
            (try? JSONEncoder().encode(pinnedTasks)).map { UserDefaults.standard.set($0, forKey: Self.pinnedTasksKey) }
        }
    }

    init() {
        do {
            tasks = try Self.tasksFromFile()
        } catch {
            tasks = []
            print("Reading tasks failed!")
        }
        
        pinnedTasks = UserDefaults.standard.data(forKey: Self.pinnedTasksKey)
            .flatMap { try? JSONDecoder().decode([Int].self, from: $0) } ?? []
    }
    
    func removeTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func reloadTasks() {
        do {
            tasks = try Self.tasksFromFile()
        } catch {
            tasks = []
            print("Reading tasks failed!")
        }
    }
    
    private static func tasksFromFile() throws -> [Task]  {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        let fileURL = folderURL.appendingPathComponent("tasks.json")
        if let data = FileManager.default.contents(atPath: fileURL.path) {
            return try JSONDecoder().decode([Task].self, from: data)
        } else {
            throw NSError(domain: "Taskify", code: 420)
        }
    }
    
    private func saveTasksToFile(_ tasks: [Task]) throws {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        let fileURL = folderURL.appendingPathComponent("tasks.json")
        let data = try JSONEncoder().encode(tasks)
        try data.write(to: fileURL)
    }
}
