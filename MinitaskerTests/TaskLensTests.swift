@testable import Minitasker
import XCTest

final class TaskLensTests: XCTestCase {

    func testIsPinnedLens() {
        let task = Task(
            id: UUID().uuidString,
            priority: .high,
            title: "",
            state: .inProgress,
            description: "",
            subtasks: [],
            deadline: nil,
            isPinned: true
        )
        
        let updatedTask = Task.isPinned.set(false, task)
        XCTAssertFalse(updatedTask.isPinned)
        let originalTask = Task.isPinned.set(true, updatedTask)
        XCTAssertEqual(task, originalTask)
    }
    
}
