import SwiftUI

@main
struct RPSApp: App {
    @StateObject var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            /*#-code-walkthrough(mlgameview.replace)*/
            MLGameView()
                .environmentObject(appModel)
        }
    }
}

