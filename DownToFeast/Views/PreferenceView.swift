import SwiftUI

struct PreferenceView: View {
    @State private var selectedCuisines: Set<CuisineType> = []
    @AppStorage("searchRadiusMiles") private var searchRadiusMiles: Double = 10.0

    var body: some View {
        VStack(spacing: 20) {
            Text("What are you craving?")
                .font(.title)
                .fontWeight(.semibold)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                ForEach(CuisineType.allCases, id: \.self) { cuisine in
                    Button(action: {
                        if selectedCuisines.contains(cuisine) {
                            selectedCuisines.remove(cuisine)
                        } else {
                            selectedCuisines.insert(cuisine)
                        }
                    }) {
                        VStack {
                            Text(cuisine.emoji)
                                .font(.title2)
                            Text(cuisine.rawValue)
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedCuisines.contains(cuisine) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedCuisines.contains(cuisine) ? .white : .black)
                        .cornerRadius(10)
                    }
                }
            }

            VStack(spacing: 8) {
                Text("Search Radius: \(Int(searchRadiusMiles)) miles")
                    .font(.headline)

                Stepper(value: $searchRadiusMiles, in: 1...50, step: 1) {
                    Text("Adjust Radius")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Button(action: {
                let preferenceStrings = selectedCuisines.map { $0.rawValue }
                UserDefaults.standard.set(preferenceStrings, forKey: "userPreferences")
                UserDefaults.standard.set(searchRadiusMiles*1609, forKey: "searchRadiusMiles")
            }) {
                Text("Save Preferences")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            selectedCuisines = CuisineType.getSavedPreferences()
        }
    }
}
