//
//  CharactersViewModel.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

final class CharactersViewModel{
        
    public func getAllCharacters(url: String, completion: @escaping (Character) -> ()){
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
