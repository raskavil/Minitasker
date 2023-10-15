import UIKit

enum QuickActionType: String {
    case newTask = "NewTask"
    case iconChange = "IconChange"
}

enum QuickAction: Equatable {
    case newTask, iconChange
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        switch QuickActionType(rawValue: shortcutItem.type) {
            case .iconChange:   self = .iconChange
            case .newTask:      self = .newTask
            case .none:         return nil
        }
    }
    
}

class QuickActionService: ObservableObject {
    static let shared = QuickActionService()
    
    @Published var action: QuickAction?
}
