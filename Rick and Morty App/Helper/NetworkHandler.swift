//
//  NetworkHandler.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//
///https://tonny.medium.com/using-swifts-generic-decodable-and-result-in-api-504164a49c0f
import Foundation

enum DataError: Error {
    case network(Error)
    case invalidResponse
    case invalidData
    case decoding
}

final class NetworkHandler{
    
    static let sharedInstance = NetworkHandler()
    typealias Completion<T> = (Swift.Result<T, DataError>) -> Void

    public func getAllCharacters<T: Decodable>(url: String, completion: @escaping Completion<T>){
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }catch {
                completion(.failure(.decoding))
            }
        }.resume()
    }
    
    
}
