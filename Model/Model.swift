import Foundation
import Combine
import SupportPackage

struct Model {
    let tasks: [Task]
    let groups: [Group]
    
    var timestamp: Date {
        (tasks.map(\.timestamp) + groups.map(\.timestamp)).sorted().last ?? .init()
    }
}

class DataModel: ObservableObject {
    
    private static let pinnedTasksKey = "minitasker.pinnedTasks"
    
    @Published var isListVisible: Bool = false
    
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

    init() {
        do {
            tasks = try Self.tasksFromFile()
        } catch {
            tasks = []
            print("Reading tasks failed!")
        }
    }
    
    func removeTask(_ task: Task) {
        tasks.removeIfPresent(task)
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
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
