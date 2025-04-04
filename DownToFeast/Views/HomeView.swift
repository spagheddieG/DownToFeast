import SwiftUI

struct HomeView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
        hasCompletedOnboarding = false
    }

    var body: some View {
        if  !isLoggedIn {
            LoginView()
        }
        else if hasCompletedOnboarding {
            RootView()
        } else {
            OnboardingView()
        }
    }
}
