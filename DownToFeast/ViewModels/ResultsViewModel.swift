import Foundation
import CoreLocation
import SwiftUI
import Combine

class ResultsViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurant: Restaurant?
    @Published var isLoading: Bool = true
    @Published var error: String?
    
    private let restaurantService = RestaurantService()
    @AppStorage("searchRadiusMiles") private var searchRadius: Double = 10
    
    var locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    
    init(restaurants: [Restaurant] = [], locationService: LocationService = LocationService()) {
        self.restaurants = restaurants
        self.locationService = locationService
        subscribeToLocationUpdates()
    }
    
    private func subscribeToLocationUpdates() {
        locationService.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                if newLocation != nil {
                    self?.fetchRestaurants()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchRestaurants() {
        guard let location = locationService.userLocation else {
            error = "Unable to determine location"
            isLoading = false
            return
        }
        
        isLoading = true
        error = nil
        
        restaurantService.fetchNearbyRestaurants(location: location, radius: searchRadius * 1609.34) { [weak self] fetchedRestaurants in
            DispatchQueue.main.async {
                self?.restaurants = fetchedRestaurants
                self?.isLoading = false
            }
        }
    }
    
    func randomRestaurant() {
        selectedRestaurant = restaurants.randomElement()
    }
}
