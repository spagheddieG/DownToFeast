import SwiftUI

struct PreferenceView: View {
    @StateObject private var viewModel = PreferenceViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("What are you craving?")
                .font(.title)
                .fontWeight(.semibold)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                ForEach(CuisineType.allCases, id: \.self) { cuisine in
                    Button(action: {
                        viewModel.toggleCuisine(cuisine)
                    }) {
                        VStack {
                            Text(cuisine.emoji)
                                .font(.title2)
                            Text(cuisine.rawValue)
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedCuisines.contains(cuisine) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(viewModel.selectedCuisines.contains(cuisine) ? .white : .black)
                        .cornerRadius(10)
                    }
                }
            }

            VStack(spacing: 8) {
                Text("Search Radius: \(Int(viewModel.searchRadiusMiles)) miles")
                    .font(.headline)

                Stepper(value: $viewModel.searchRadiusMiles, in: 1...50, step: 1) {
                    Text("Adjust Radius")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Button(action: {
                viewModel.savePreferences()
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
    }
}
