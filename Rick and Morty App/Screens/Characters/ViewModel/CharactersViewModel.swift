//
//  CharactersViewModel.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

final class CharactersViewModel{
    
    fileprivate let url = "https://rickandmortyapi.com/api/character"    
    
    public func getAllCharacters(completion: @escaping (Character) -> ()){
        NetworkHandler.sharedInstance.getAllCharacters(
            url: url) { (result: Swift.Result<Character, DataError>) in
                switch result {
                case .success(let character):
                    completion(character)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}
