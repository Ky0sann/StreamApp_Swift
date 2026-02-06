//
//  GuestPeopleListView.swift
//  stream_app
//
//  Created by Cours on 06/02/2026.
//

import SwiftUI

struct GuestPeopleListView: View {
    @StateObject private var vm = PeopleViewModel()

    var body: some View {
        NavigationStack {
            List(vm.people) { person in
                NavigationLink(destination: PersonDetailView(person: person)) {
                    HStack {
                        if let url = person.profileURL {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(6)
                        }

                        VStack(alignment: .leading) {
                            Text(person.name).bold()
                            Text(person.known_for_department ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Cast")
            .searchable(text: $vm.searchText, prompt: "Rechercher une personne")
            .onChange(of: vm.searchText) { _, _ in
                Task {
                    await vm.search()
                }
            }
            .task {
                await vm.loadPopular()
            }
        }
    }
}
