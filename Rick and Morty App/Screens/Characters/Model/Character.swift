//
//  Character.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

// MARK: - Character
struct Character: Codable{
    let info: Info
    let results: [Result]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Result: Codable, Hashable{
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
