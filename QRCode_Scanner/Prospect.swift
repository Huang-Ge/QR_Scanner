//
//  Prospect.swift
//  HotProspects
//
//  Created by Paul Hudson on 03/01/2022.
//

import SwiftUI

class Prospect: Identifiable, Codable, Equatable {
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name == rhs.name && lhs.emailAddress == rhs.emailAddress
    }
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }

        // no saved data!
        people = []
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    func delete(_ prospect: Prospect) {
        objectWillChange.send()
        if let idx = people.firstIndex(where: { $0 === prospect }) {
            people.remove(at: idx)
        }
        save()
    }
}
