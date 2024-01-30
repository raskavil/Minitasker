import SwiftUI

@main
struct MinitaskerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let actionService = QuickActionService.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    TaskList()
                }
                .environmentObject(actionService)
                .navigationViewStyle(.stack)
                .accentColor(.primary)
                .tabItem { Label("Tasks", systemImage: "list.bullet") }
                NavigationView {
                    GroupList(groups: [
                        .init(id: "", title: "Grupka1", tasks: ["sds"], deadline: nil)
                    ])
                }
                .navigationViewStyle(.stack)
                .accentColor(.primary)
                .tabItem { Label("Groups", systemImage: "rectangle.3.group") }
            }
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
