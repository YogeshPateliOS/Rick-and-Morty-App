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

// MARK: - Result
struct Character: Codable, Hashable {
    let id = UUID() /// API Contains duplicate values so need to be unique so use UUID here
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

    private enum CodingKeys: String, CodingKey {
        case name, status, species, type, gender
        case origin, location, image, episode, url, created
    }

}

// MARK: - Location
struct Location: Codable, Hashable {
    let name: String
    let url: String
}

struct EpisodeDetail: Codable {
    let id: Int
    let name: String
    let episode: String
    let airDate: String
    private enum CodingKeys: String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}
