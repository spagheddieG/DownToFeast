import CoreLocation

struct OSMResponse: Decodable {
    let elements: [Element]
}

struct Element: Decodable {
    let id: Int64
    let lat: Double
    let lon: Double
    let tags: [String: String]?
}

class RestaurantService {
    private func loadUserPreferences() -> Set<CuisineType> {
        return CuisineType.getSavedPreferences()
    }

    func fetchNearbyRestaurants(location: CLLocation, radius: Double = 10000, completion: @escaping ([Restaurant]) -> Void) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        let overpassQuery = """
        [out:json];
        node
          ["amenity"="restaurant"]
          (around:\(Int(radius)),\(lat),\(lon));
        out;
        """

        guard let queryData = overpassQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://overpass-api.de/api/interpreter?data=\(queryData)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let result = try JSONDecoder().decode(OSMResponse.self, from: data)
                let restaurants = result.elements.map {
                    Restaurant(
                        id: String($0.id),
                        name: $0.tags?["name"] ?? "Unnamed Restaurant",
                        cuisine: $0.tags?["cuisine"] ?? "",
                        address: "\(String(format: "%.4f", $0.lat)), \(String(format: "%.4f", $0.lon))",
                        distanceInMeters: location.distance(from: CLLocation(latitude: $0.lat, longitude: $0.lon))
                    )
                }
                
                let preferences = self.loadUserPreferences()
                if !preferences.isEmpty {
                    let filtered = restaurants.filter { restaurant in
                        preferences.contains { cuisineType in
                            restaurant.cuisine.localizedCaseInsensitiveContains(cuisineType.rawValue) ||
                            restaurant.name.localizedCaseInsensitiveContains(cuisineType.rawValue)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(filtered)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(restaurants)
                    }
                }
            } catch {
                print("OSM decode error: \(error)")
                completion([])
            }
        }.resume()
    }
}
