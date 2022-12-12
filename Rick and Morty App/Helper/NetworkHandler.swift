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
    case invalidURL
    case decoding
}

typealias APIResponseBlock<T> = (Result<T, DataError>)

// Singleton Pattern for networking API
final class NetworkHandler {

    static let shared = NetworkHandler()
    private init() {} // Singleton - No one can make instance outside of the class

    /// Generic API Calling
    /// - Parameter url: Pass the API URL
    /// - Returns: It will return model response and error in form of DataError
    func get<T: Decodable>(url: String) async -> APIResponseBlock<T>{
        guard let url = URL(string: url) else {
            return .failure(.invalidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                return .failure(.invalidResponse)
            }
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(.decoding)
            }
            return .success(decodedData)
        } catch  {
            return .failure(.network(error))
        }
    }
}
