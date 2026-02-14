import SwiftUI

@main
struct RPSApp: App {
    @StateObject var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            MLGameView()
                .environmentObject(appModel)
        }
    }
}

