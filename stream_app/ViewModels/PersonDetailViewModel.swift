import Foundation

@MainActor
class PersonDetailViewModel: ObservableObject {
    @Published var cast: [PersonMovie] = []
    @Published var crew: [PersonMovie] = []

    private let service = TMDBPeopleService()

    func load(person: Person) async {
        do {
            let credits = try await service.fetchCredits(for: person.id)
            cast = credits.cast
            crew = credits.crew
        } catch {
            print(error)
        }
    }
}

