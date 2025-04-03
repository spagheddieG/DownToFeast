import SwiftUI
import CoreLocation

struct ResultsView: View {
    @StateObject private var locationService = LocationService()
    @State private var restaurants: [Restaurant] = []
    @State private var selectedRestaurant: Restaurant?
    @State private var isLoading = true
    @State private var error: String?
    
    private let restaurantService = RestaurantService()
    @AppStorage("searchRadiusMiles") private var searchRadius: Double = 10000
        
    
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
    
    var body: some View {
        Group {
            if locationService.permissionDenied {
                Text("Location access is required to find nearby restaurants")
                    .foregroundColor(.red)
                    .padding()
            } else if isLoading {
                ProgressView("Finding restaurants...")
            } else if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if restaurants.isEmpty {
                Text("No restaurants found nearby")
                    .padding()
            } else {
                restaurantListView
            }
        }
        .onAppear(perform: fetchRestaurants)
        .onChange(of: locationService.userLocation) { oldValue, newValue in
            fetchRestaurants()
        }
    }
    
    private var restaurantListView: some View {
        VStack(spacing: 20) {
            Button("I'm Down to Feast!") {
                selectedRestaurant = restaurants.randomElement()
            }
            .buttonStyle(.borderedProminent)
            
            if let pick = selectedRestaurant {
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
                    Text(String(format: "%.1f km away", pick.distanceInMeters / 1000))
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                List(restaurants.sorted { $0.distanceInMeters < $1.distanceInMeters }) { restaurant in
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
                        Text(String(format: "%.1f km away", restaurant.distanceInMeters / 1000))
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Nearby Restaurants")
    }
    
    private func fetchRestaurants() {
        guard let location = locationService.userLocation else {
            error = "Unable to determine location"
            isLoading = false
            return
        }
        
        isLoading = true
        error = nil
        
        restaurantService.fetchNearbyRestaurants(location: location, radius: searchRadius) { fetchedRestaurants in
            restaurants = fetchedRestaurants
            isLoading = false
        }
    }
}
