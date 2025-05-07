import SwiftUI

enum MenuState { case home }

final class AppManager: ObservableObject {
    static var instance = AppManager()
    private init() {}
    
    @Published var menuState: MenuState = .home
}
