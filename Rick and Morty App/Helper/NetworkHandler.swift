//
//  NetworkHandler.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

// API Error cases - ENUM
enum DataError: Error {
    case invalidURL
    case invalidResponse
    case network(Error)
}

final class NetworkHandler {

    /// Generic API Calling
    /// - Parameter url: Pass the API URL
    /// - Returns: It will return model response and error in form of DataError
    func request<T: Decodable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw DataError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
