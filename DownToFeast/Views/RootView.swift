import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient for a modern look.
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 0.533, green: 0.690, blue: 0.294),
                    Color(red: 0.353, green: 0.541, blue: 0.235)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                // Main content card with subtle styling.
                mainContent
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .padding()
            }
            .navigationDestination(isPresented: $viewModel.navigateToResults) {
                ResultsView()
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 20) {
            // Title with custom font and shadow.
            Text("Find Food")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
            
            // Styled NavigationLink as a button.
            NavigationLink(destination: PreferenceView()) {
                Text("View Preferences")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            
            // Custom-styled Search button.
            Button(action: {
                viewModel.search()
            }) {
                Text("Search")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
    }
}
