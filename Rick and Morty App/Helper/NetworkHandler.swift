//
//  NetworkHandler.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

// API Error cases - ENUM
enum DataError: Error {
    case network(Error)
    case invalidResponse
    case invalidData
    case decoding
}

typealias APIResponseBlock<T> = (Result<T, DataError>) -> Void

// Singleton Pattern for networking API
final class NetworkHandler {

    static let shared = NetworkHandler()
    private init() {} // Singleton - No one can make instance outside of the class

    /// Generic API Calling
    /// - Parameters:
    ///   - url: pass the API URL
    ///   - completion: It will return model response and error in form of DataError
    func get<T: Decodable>(url: String, completion: @escaping APIResponseBlock<T>) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
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
                /// JSONDecoder to parse data - API Response to Model
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decoding))
                }
            }
        }.resume()
    }

}
