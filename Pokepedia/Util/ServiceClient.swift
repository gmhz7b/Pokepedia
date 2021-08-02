import Foundation

final class ServiceClient {
    
    /// Retrieves data from service, given a `URL`.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which the `Decodable` type is retrieved.
    ///   - completion: A closure called once the network task completes.
    ///   Contains a `Result` parameter who's `success` case contains a `Data` object,
    ///   and who's `failure` case contains an `Error`.
    func get(from url: URL, completion: @escaping (Result<Data, Swift.Error>) -> ()) {
        
        // Create the request.
        let request = URLRequest(url: url)
        
        // Create the session.
        let session = URLSession(configuration: .default)
        
        // Create the data task.
        let task = session.dataTask(with: request) { [weak self] in
            
            // Handle the response.
            self?.parse(data: $0, response: $1, error: $2, completion: completion)
        }
        
        // Resume the task and instruct the session to invalidate when finished.
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

extension ServiceClient {
    
    /// A method that handles the parsing of a network response.
    ///
    /// - Parameters:
    ///   - data: The `Data?` returned from service.
    ///   - response: The `URLResponse?` returned from service.
    ///   - error: The `Swift.Error?` returned from service.
    ///   - completion: A closure called once the network task completes.
    ///   Contains a `Result` parameter who's `success` case contains a `Data` object,
    ///   and who's `failure` case contains an `Error`.
    private func parse(
        data: Data?,
        response: URLResponse?,
        error: Swift.Error?,
        completion: @escaping (Result<Data, Swift.Error>) -> ()
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

        // Complete with the resulting data.
        completion(.success(data))
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
