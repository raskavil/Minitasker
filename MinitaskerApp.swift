import SwiftUI

@main
struct MinitaskerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TaskList()
            }
            .navigationViewStyle(.stack)
            .accentColor(.primary)
        }
    }
}
