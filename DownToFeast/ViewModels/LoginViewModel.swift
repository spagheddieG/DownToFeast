import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    func login() {
        // Validate credentials here if needed.
        // For now, simply assume login is successful.
        isLoggedIn = true
    }
}
