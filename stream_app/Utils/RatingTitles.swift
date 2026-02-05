import Foundation

struct RatingTitles {
    static func title(for rating: Double) -> String {
        switch rating {
        case 0.5: return "Nul"
        case 1.0: return "Très mauvais"
        case 1.5: return "Mauvais"
        case 2.0: return "Bof"
        case 2.5: return "Moyen"
        case 3.0: return "Sympa"
        case 3.5: return "Bon"
        case 4.0: return "Très bon"
        case 4.5: return "Excellent"
        case 5.0: return "Chef-d’œuvre"
        default: return ""
        }
    }
}

