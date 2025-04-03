# DownToFeast

DownToFeast is a SwiftUI-based iOS application that helps users discover nearby restaurants based on their cuisine preferences and search radius. The app leverages the device's location services to find eateries in the vicinity and features a playful “I'm Down to Feast!” button that randomly selects a restaurant for you.

## Features

- **Cuisine Preferences:**  
  Users can select their desired cuisines to tailor the restaurant search.

- **Custom Search Radius:**  
  Enter the search radius in miles directly, with results shown based on the provided radius.

- **Location Integration:**  
  Utilizes a dedicated `LocationService` to retrieve and monitor the user's current location for nearby restaurant searches.

- **Random Restaurant Selector:**  
  With a tap of the "I'm Down to Feast!" button, the app picks a random restaurant from the search results.

- **Clean Architecture:**  
  The app is structured with a clear separation of concerns. The UI is decoupled from the business logic using View Models:
  - **RootViewModel:** Handles search initiation and navigation.
  - **ResultsViewModel:** Manages restaurant search results, integrates with `LocationService`, and handles restaurant selection.

## Installation

1. **Clone the Repository:**

   ```bash
   git clone git@github.com:spagheddieG/DownToFeast.git
   ```

2. **Open in Xcode:**

   Navigate to the project directory and open the `DownToFeast.xcodeproj` file in Xcode.

3. **Build and Run:**

   Select the appropriate simulator or device and hit **Run**.

## Usage

- **Preferences:**  
  Open the app and navigate to the Preferences screen to select your desired cuisines and adjust your search radius.

- **Search:**  
  Tap on the **Search** button from the home screen to find nearby restaurants based on your preferences and current location.

- **Random Selection:**  
  In the results view, tap on **I'm Down to Feast!** to let the app choose a restaurant randomly from the list.

## Architecture

DownToFeast is built using SwiftUI and leverages Combine for reactive programming. Key components include:

- **Views:**
  - `RootView`: The main entry point of the application.
  - `PreferenceView`: Handles user settings such as cuisine preferences and search radius.
  - `ResultsView`: Displays the list of nearby restaurants and handles random selection.

- **View Models:**
  - `RootViewModel`: Manages overall navigation and search state.
  - `ResultsViewModel`: Subscribes to location updates and fetches nearby restaurants using a dedicated `RestaurantService`.

- **Services:**
  - `LocationService`: Provides access to the device's location data and updates.
  - `RestaurantService`: Handles the logic for fetching restaurants based on the user’s location and preferences.

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
