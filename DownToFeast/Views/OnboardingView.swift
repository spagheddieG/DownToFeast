import SwiftUI

struct OnboardingView: View {
    @State private var cuisineCards: [CuisineCard] = CuisineType.allCases.map { CuisineCard(type: $0) }
    @State private var selectedPreferences: Set<CuisineType> = []
    @State private var isCompleted = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("What food do you like?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Swipe right to like, left to skip")
                    .foregroundColor(.gray)
                
                ZStack {
                    ForEach(cuisineCards.reversed()) { card in
                        CardView(card: card, onSwipe: { direction in
                            if direction == .right {
                                selectedPreferences.insert(card.type)
                            }
                            removeCard(card)
                        })
                    }
                }
                .padding()
                
                if cuisineCards.isEmpty {
                    Button("Get Started") {
                        savePreferences()
                        hasCompletedOnboarding = true
                        isCompleted = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationDestination(isPresented: $isCompleted) {
                HomeView()
            }
        }
    }
    
    private func removeCard(_ card: CuisineCard) {
        cuisineCards.removeAll { $0.id == card.id }
    }
    
    private func savePreferences() {
        let preferenceStrings = selectedPreferences.map { $0.rawValue }
        UserDefaults.standard.set(preferenceStrings, forKey: "userPreferences")
    }
}

struct CuisineCard: Identifiable, Equatable {
    var id = UUID()
    let type: CuisineType
    
    static func == (lhs: CuisineCard, rhs: CuisineCard) -> Bool {
        lhs.id == rhs.id
    }
}

struct CardView: View {
    let card: CuisineCard
    let onSwipe: (SwipeDirection) -> Void
    
    @State private var offset = CGSize.zero
    @State private var rotation = 0.0
    
    private var swipeDirection: SwipeDirection {
        if offset.width > 50 {
            return .right
        } else if offset.width < -50 {
            return .left
        }
        return .none
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
            
            VStack {
                Text(card.type.emoji)
                    .font(.system(size: 80))
                Text(card.type.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if swipeDirection != .none {
                    Text(swipeDirection == .right ? "Like" : "Skip")
                        .font(.headline)
                        .foregroundColor(swipeDirection == .right ? .green : .red)
                        .padding(.top)
                }
            }
            .overlay(alignment: .topLeading) {
                if swipeDirection == .left {
                    Text("✕")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .overlay(alignment: .topTrailing) {
                if swipeDirection == .right {
                    Text("♥")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .frame(width: 300, height: 400)
        .rotationEffect(.degrees(rotation))
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    rotation = Double(gesture.translation.width / 20)
                }
                .onEnded { gesture in
                    let direction = swipeDirection
                    if direction != .none {
                        onSwipe(direction)
                    }
                    withAnimation {
                        offset = .zero
                        rotation = 0
                    }
                }
        )
    }
}

enum SwipeDirection {
    case left, right, none
}

enum CuisineType: String, CaseIterable, Codable {
    case mexican = "Mexican"
    case italian = "Italian"
    case japanese = "Japanese"
    case chinese = "Chinese"
    case indian = "Indian"
    case american = "American"
    case thai = "Thai"
    case mediterranean = "Mediterranean"
    
    var emoji: String {
        switch self {
        case .mexican: return "🌮"
        case .italian: return "🍝"
        case .japanese: return "🍱"
        case .chinese: return "🥡"
        case .indian: return "🍛"
        case .american: return "🍔"
        case .thai: return "🍜"
        case .mediterranean: return "🥙"
        }
    }
}

extension CuisineType {
    static func getSavedPreferences() -> Set<CuisineType> {
        guard let savedStrings = UserDefaults.standard.array(forKey: "userPreferences") as? [String] else {
            return []
        }
        return Set(savedStrings.compactMap { rawValue in
            CuisineType(rawValue: rawValue)
        })
    }
}
