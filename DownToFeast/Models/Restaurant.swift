import CoreLocation

struct Restaurant: Identifiable {
    let id: String
    let name: String
    let cuisine: String
    let address: String
    let distanceInMeters: CLLocationDistance
}
