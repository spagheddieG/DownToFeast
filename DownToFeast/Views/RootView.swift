import SwiftUI

struct RootView: View {
    @State private var navigateToResults = false
    @State private var restaurants: [Restaurant] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Find Food")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                NavigationLink("View Preferences") {
                    PreferenceView()
                }
                .foregroundColor(.blue)
                
                Button("Search") {
                    navigateToResults = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToResults) {
                ResultsView(restaurants: restaurants)
            }
        }
    }
}
