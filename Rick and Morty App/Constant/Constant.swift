//
//  Constant.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

/// Enum and Struct Value type so space bav na roke
/// https://medium.com/swift-india/defining-global-constants-in-swift-a80d9e5cbd42

enum Constants {

    static let alive = "Alive"
    static let languageCodeKey = "LanguageCode"

    enum API {
        static let baseURL = "https://rickandmortyapi.com/api/"
        static let characterURL = "\(baseURL)character"
        static let filterCharacterURL = "\(characterURL)/?name="
    }

    enum Identifier {
        static let cell = "cell"
    }

    enum Localizable{
        static var search: String { "SearchKey".localizableString() }
        static var episodes: String { "EpisodesKey".localizableString() }
        static var loading: String { "LoadingKey".localizableString() }
        static var connectivity: String { "ConnectivityKey".localizableString() }
        static var characters: String { "CharactersKey".localizableString() }
        static var loadMore: String { "LoadMoreKey".localizableString() }
        static var status: String { "StatusKey".localizableString() }
        static var specie: String { "SpecieKey".localizableString() }
        static var appearance: String { "AppearanceKey".localizableString() }
        static var info: String { "InfoKey".localizableString() }
        static var gender: String { "GenderKey".localizableString() }
        static var location: String { "LocationKey".localizableString() }
        static var nameNotAvailable: String{ "NameNotAvailableKey".localizableString() }
    }
    
}

enum LanguageCode: String, CaseIterable{
    case english = "en"
    case Spanish = "es"
    case French = "fr"
}
