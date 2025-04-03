import SwiftUI

class PreferenceViewModel: ObservableObject {
    @Published var selectedCuisines: Set<CuisineType> = []
    @AppStorage("searchRadiusMiles") var searchRadiusMiles: Double = 10.0

    init() {
        loadPreferences()
    }

    func toggleCuisine(_ cuisine: CuisineType) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
    }

    func savePreferences() {
        let preferenceStrings = selectedCuisines.map { $0.rawValue }
        UserDefaults.standard.set(preferenceStrings, forKey: "userPreferences")
        UserDefaults.standard.set(searchRadiusMiles * 1609, forKey: "searchRadiusMiles")
    }

    private func loadPreferences() {
        selectedCuisines = CuisineType.getSavedPreferences()
    }
}
