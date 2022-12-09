//
//  Constant.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

/// Enum and Struct Value type so space bav na roke
/// https://medium.com/swift-india/defining-global-constants-in-swift-a80d9e5cbd42
enum Constants {
    
    static let search = "Search"
    static let alive = "Alive"
    static let episodes = "EPISODES"
    enum API{
        static let baseURL = "https://rickandmortyapi.com/api/"
        static let characterURL = "\(baseURL)character"
        static let filterCharacterURL = "\(baseURL)character/?name="
    }
    
    enum NavTitle{
        static let characters = "Characters"
    }
    
    enum Idetifier{
        static let cell = "cell"
    }
    
    
}
