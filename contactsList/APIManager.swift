//
//  Url .swift
//  contactsList
//
//  Created by K V Jagadeesh babu on 22/01/25.
//

import Foundation

class APIManager {
    
    private let baseURL = "https://jsonplaceholder.typicode.com/users"
    
    func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                print("API Response \(String(describing: String(data: data!, encoding: .utf8)))")
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let contacts = try JSONDecoder().decode([Contact].self, from: data)
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided is invalid."
        case .invalidResponse: return "The response from the server is invalid."
        case .noData: return "No data was returned from the server."
        }
    }
}



