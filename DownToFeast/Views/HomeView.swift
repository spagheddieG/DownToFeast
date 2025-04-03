import SwiftUI

struct HomeView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        hasCompletedOnboarding = false
    }

    var body: some View {
        if hasCompletedOnboarding {
            RootView()
        } else {
            OnboardingView()
        }
    }
}
