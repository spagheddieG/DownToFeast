import SwiftUI
import CoreLocation

struct ResultsView: View {
    @StateObject private var viewModel = ResultsViewModel()
    @State private var showCelebration = false

    var body: some View {
        Group {
            if viewModel.locationService.permissionDenied {
                Text("Location access is required to find nearby restaurants")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.isLoading {
                ProgressView("Finding restaurants...")
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.restaurants.isEmpty {
                Text("No restaurants found nearby")
                    .padding()
            } else {
                restaurantListView
            }
        }
        .onAppear(perform: viewModel.fetchRestaurants)
    }
    
    private var restaurantListView: some View {
        VStack(spacing: 20) {
            Button("I'm Down to Feast!") {
                showCelebration = true
                viewModel.randomRestaurant()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showCelebration = false
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let pick = viewModel.selectedRestaurant {
                ZStack {
                    if showCelebration {
                        CelebrationView()
                            .ignoresSafeArea()
                            .transition(.opacity)
                    }
                    VStack(spacing: 10) {
                        Text("You should eat at:")
                            .font(.headline)
                        Text(pick.name)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        if !pick.cuisine.isEmpty {
                            Text("Cuisine: \(pick.cuisine)")
                                .foregroundColor(.secondary)
                        }
                        Text(pick.address)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f miles away", pick.distanceInMeters / 1609.34))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            } else {
                List(viewModel.restaurants.sorted { $0.distanceInMeters < $1.distanceInMeters }) { restaurant in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(restaurant.name)
                            .font(.headline)
                        if !restaurant.cuisine.isEmpty {
                            Text("Cuisine: \(restaurant.cuisine)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Text(restaurant.address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f miles away", restaurant.distanceInMeters / 1609.34))
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Nearby Restaurants")
    }
}

struct CelebrationView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Configure confetti emitter
        let confettiEmitter = CAEmitterLayer()
        confettiEmitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        confettiEmitter.emitterShape = .line
        confettiEmitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        confettiEmitter.emitterCells = generateConfettiCells()
        view.layer.addSublayer(confettiEmitter)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    private func generateConfettiCells() -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = []
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemYellow]
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 3
            cell.lifetime = 5.0
            cell.velocity = 150
            cell.velocityRange = 50
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scale = 0.05
            cell.scaleRange = 0.02
            cell.color = color.cgColor
            cell.contents = UIImage(systemName: "circle.fill")?.cgImage
            cells.append(cell)
        }
        return cells
    }
    
}
