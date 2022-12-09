//
//  Character.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

// MARK: - Character
struct CharacterResponseModel: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
///https://stackoverflow.com/a/60455131/8201581
// MARK: - Result
struct Character: Codable {
    let uuid = UUID()
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    private enum CodingKeys : String, CodingKey {
        case id, name, status, species, type, gender
        case origin, location, image, episode, url, created
    }

}

extension Character : Hashable {
    static func ==(lhs: Character, rhs: Character) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

//enum Gender: String, Codable {
//    case female = "Female"
//    case male = "Male"
//    case unknown = "unknown"
//}

// MARK: - Location
struct Location: Codable, Hashable {
    let name: String
    let url: String
}

//enum Species: String, Codable {
//    case alien = "Alien"
//    case human = "Human"
//}

//enum Status: String, Codable {
//    case alive = "Alive"
//    case dead = "Dead"
//    case unknown = "unknown"
//}

//struct Result: Codable, Hashable{
//}

struct EpisodeDetail: Codable{
    let id: Int
    let name: String
    let episode: String
    let airDate: String
    private enum CodingKeys : String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}
