enum Category: String, Codable, CaseIterable {
    case food, entertainment, housing, health, transport

    var name: String {
        rawValue.capitalized
    }

    var imageName: String {
        switch self {
        case .food:
            return "cart.fill"
        case .entertainment:
            return "video.fill"
        case .housing:
            return "house.fill"
        case .health:
            return "heart.fill"
        case .transport:
            return "car.fill"
        }
    }
}

extension Category: Identifiable {
    var id: String {
        rawValue
    }
}
