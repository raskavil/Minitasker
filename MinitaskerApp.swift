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
