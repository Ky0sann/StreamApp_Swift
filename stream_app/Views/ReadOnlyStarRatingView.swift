import SwiftUI

struct ReadOnlyStarRatingView: View {
    let rating: Double
    let maxRating = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                let starValue = Double(index)
                Image(systemName: imageName(for: starValue))
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
        }
    }

    private func imageName(for star: Double) -> String {
        if rating >= star {
            return "star.fill"
        } else if rating >= star - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
