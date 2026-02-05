import SwiftUI

struct PersonDetailView: View {
    let person: Person
    @StateObject private var vm = PersonDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let url = person.profileURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(12)
                }

                Text(person.name)
                    .font(.title)
                    .bold()

                if !vm.cast.isEmpty {
                    Text("🎭 Films (acteur)")
                        .font(.headline)

                    ForEach(vm.cast) { movie in
                        Text(movie.title ?? "—")
                    }
                }

                if !vm.crew.isEmpty {
                    Text("🎬 Réalisations / équipe")
                        .font(.headline)

                    ForEach(vm.crew) { movie in
                        Text("\(movie.title ?? "") — \(movie.job ?? "")")
                    }
                }
            }
            .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.load(person: person)
        }
    }
}

