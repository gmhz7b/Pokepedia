import Foundation

final class ServiceClient {
    
    /// Retrieves and decodes a specified type from service, given a `URL`.
    ///
    /// This method, when called, requires a generic type `T` that conforms to `Decodable`
    /// to be specified.
    ///
    /// The specified type is used as the guiding type to be decoded from service
    /// when parsing the response.
    ///
    /// Consult `PokemonDetailsModel` for invocation examples.
    ///
    /// - Parameters:
    ///   - type: The `Decodable` type to be retrieved.
    ///   - url: The `URL` from which the `Decodable` type is retrieved.
    ///   - completion: A closure called once the network task completes.
    ///   Contains a `Result` parameter who's `success` case contains an instance of the `Decodable` type,
    ///   and who's `failure` case contains an `Error`.
    func get<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, Swift.Error>) -> ()) {
        
        // Create the request.
        let request = URLRequest(url: url)
        
        // Create the session.
        let session = URLSession(configuration: .default)
        
        // Create the data task.
        let task = session.dataTask(with: request) { [weak self] in
            
            // Handle the response.
            self?.parse(type: T.self, from: $0, response: $1, error: $2, completion: completion)
        }
        
        // Resume the task and instruct the session to invalidate when finished.
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

extension ServiceClient {
    
    /// A method that handles the parsing of a network response.
    ///
    /// This method, when called, requires a generic type `T` that conforms to `Decodable`
    /// to be specified.
    ///
    /// The specified type is used as the guiding type to be decoded when parsing
    /// the response.
    ///
    /// Consult `get(_:,from:,completion:)` for invocation examples.
    ///
    /// - Parameters:
    ///   - type: The `Decodable` type to be retrieved.
    ///   - data: The `Data?` returned from service.
    ///   - response: The `URLResponse?` returned from service.
    ///   - error: The `Swift.Error?` returned from service.
    ///   - completion: A closure called once the network task completes.
    ///   Contains a `Result` parameter who's `success` case contains an instance of the `Decodable` type,
    ///   and who's `failure` case contains an `Error`.
    private func parse<T: Decodable>(
        type: T.Type,
        from data: Data?,
        response: URLResponse?,
        error: Swift.Error?,
        completion: @escaping (Result<T, Swift.Error>) -> ()
    ) {
        
        // Check for response errors.
        if let error = error {
            completion(.failure(error))
        }
        
        // Ensure the response is returned in the correct format.
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(Error.invalidResponse))
            return
        }
        
        // Ensure the status code falls within the "success" range.
        guard 200...299 ~= httpResponse.statusCode else {
            let localizedDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            completion(.failure(Error.invalidStatusCode(localizedDescription)))
            return
        }
        
        // Ensure that data was returned.
        guard let data = data else {
            completion(.failure(Error.noData))
            return
        }
        
        // Create and configure a `JSONDecoder` to decode the data.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Attempt to decode the data as the specified type `T`.
        //
        // Complete with the result of the decoding attempt.
        completion(Result { try decoder.decode(T.self, from: data) })
    }
}

extension ServiceClient {
    
    /// An `enum` representing various custom `Error`s encountered while parsing a network response.
    private enum Error: CustomNSError {
        case invalidResponse
        case invalidStatusCode(String)
        case noData
        
        var errorUserInfo: [String: Any] {
            switch self {
            case .invalidResponse:
                return [NSLocalizedDescriptionKey: "Invalid response"]
                
            case .invalidStatusCode(let localizedDescription):
                return [NSLocalizedDescriptionKey: localizedDescription]
                
            case .noData:
                return [NSLocalizedDescriptionKey: "No data."]
            }
        }
    }
}
