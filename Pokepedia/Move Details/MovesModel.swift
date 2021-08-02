import Foundation

/// A `Delegate` acting on behalf of a `MovesModel` instance.
///
/// - SeeAlso: `MovesModel`.
protocol MovesModelDelegate: AnyObject {
    
    /// Called to notify the UI that a download will occur.
    func willDownload()
    
    /// Called when a displayable value is received and successfully decoded from service.
    ///
    /// - Parameters:
    ///   - move: The `Move` to be displayed.
    ///   - title: A title for the `Move` value.
    func received(move: Move, withTitle title: String)
    
    /// Called when an `Error` is encountered while attempting to retrieve a `Move` from service.
    func received(error: Error)
}

/// The model used by `MovesViewController` to display a `Pokémon`'s `moves` array.
///
/// - SeeAlso: `MovesViewController`.
/// - SeeAlso: `ViewPokemonMovesAction`.
final class MovesModel {
    private let serviceClient: ServiceClient
    
    /// - SeeAlso: `MovesModel.Item`.
    let items: [Item]
    
    weak var delegate: MovesModelDelegate?
    
    /// - Parameters:
    ///   - serviceClient: An object that retrieves data for a given type from a `URL`.
    ///   - items: The items to be displayed by `MovesViewController`.
    init(serviceClient: ServiceClient, items: [Item]) {
        self.serviceClient = serviceClient
        self.items = items
    }
    
    /// A method that notifies the model that a user selected a `MovesModel.Item` row.
    ///
    /// - Parameter row: The row selected by the user.
    func userTapped(_ row: Int) {
        
        // Notify the UI that a download will occur.
        delegate?.willDownload()
        
        // Locate the item selected.
        let item = items[row]
        
        // Perform a networking task to retrieve data about the selected item.
        //
        // See `ServiceClient` for networking implementation details.
        serviceClient.get(from: item.url) { [weak self] result in
            do {
                
                // Attempt to extract the data from the result.
                let data = try result.get()
                
                // Create and configure a `JSONDecoder` to decode the data.
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Attempt to decode a `Move` object from the data.
                let move = try decoder.decode(Move.self, from: data)
                
                // Notify the UI that a successful `Move` was received.
                self?.delegate?.received(move: move, withTitle: item.title)
            } catch {
                
                // Notify the UI that an `Error` was encountered.
                self?.delegate?.received(error: error)
            }
        }
    }
}

extension MovesModel {
    
    /// A `struct` representing an item to be displayed in `MovesViewController`.
    ///
    /// - SeeAlso: `MovesViewController`.
    struct Item {
        let title: String
        let detail: String
        let url: URL
    }
}
