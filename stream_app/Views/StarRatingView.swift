import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Double
    let maxRating = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                let starValue = Double(index)

                Image(systemName: imageName(for: starValue))
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        if rating == starValue {
                            rating = starValue - 0.5
                        } else {
                            rating = starValue
                        }
                    }
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

