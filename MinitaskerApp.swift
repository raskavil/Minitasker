import SwiftUI

@main
struct MinitaskerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let actionService = QuickActionService.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TaskList()
            }
            .environmentObject(actionService)
            .navigationViewStyle(.stack)
            .accentColor(.primary)
        }
    }
}

extension String {
    
    static func localized(_ key: String) -> String {
        let value = NSLocalizedString(key, comment: "")
        
        if value != key {
            return value
        }
        
        guard
            let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
            let bundle = Bundle(path: path)
        else { return value }
        
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
    
}
