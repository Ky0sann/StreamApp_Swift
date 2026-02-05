import Foundation

@MainActor
class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var searchText = ""

    private let service = TMDBPeopleService()

    func loadPopular() async {
        do {
            people = try await service.fetchPopularPeople()
        } catch {
            print(error)
        }
    }

    func search() async {
        guard !searchText.isEmpty else {
            await loadPopular()
            return
        }

        do {
            people = try await service.searchPeople(query: searchText)
        } catch {
            print(error)
        }
    }
}

