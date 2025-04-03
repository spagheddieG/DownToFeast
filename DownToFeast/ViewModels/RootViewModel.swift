//
//  RootViewModel.swift
//  DownToFeast
//
//  Created by Eddie Gomez on 4/2/25.
//

import Foundation
import Combine

class RootViewModel: ObservableObject {
    @Published var navigateToResults: Bool = false
    @Published var restaurants: [Restaurant] = []
    
    /// Initiates a search and updates the results.
    func search() {
        // TODO: Replace with actual search logic, e.g., an API call or local filtering.
        // For now, simulate a search by setting `navigateToResults` to true.
        navigateToResults = true
        
        // Optionally update `restaurants` with search results.
        // restaurants = RestaurantService.fetchRestaurants() // Example call
    }
}
