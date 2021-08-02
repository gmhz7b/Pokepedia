import Foundation

/// A `Delegate` acting on behalf of a `PokemonDetailsModel` instance.
///
/// - SeeAlso: `PokemonDetailsModel`.
protocol DetailsModelDelegate: AnyObject {
    
    /// Called to notify the UI that a download will occur.
    func willDownload()
    
    /// Called when a displayable value is received and successfully decoded from service.
    ///
    /// - Parameters:
    ///   - displayable: The value to be displayed.
    ///   - title: A title for the `Displayable` value.
    func received(displayable: Displayable, withTitle title: String)
    
    /// Called when an `Error` is encountered while attempting to retrieve a `Displayable`
    /// value from service.
    func received(error: Error)
}

/// The model used by `PokemonDetailsViewController` to display a list attribute
/// of a `Pokémon` object.
///
/// This model, when initialized, requires a generic type `T` that conforms to both `Displayable & Decodable`
/// to be specified.
///
/// The specified type is used as the guiding type to be decoded from service and
/// displayed in an additional `UIViewController` (specifically `PokemonDetailViewController`).
///
/// Consult `ViewPokemonDetailsAction` for invocation examples.
///
/// - SeeAlso: `PokemonDetailsViewController`.
/// - SeeAlso: `ViewPokemonDetailsAction`.
final class PokemonDetailsModel<T: Displayable & Decodable> {
    private let serviceClient: ServiceClient
    
    let items: [DetailsItem]
    
    weak var delegate: DetailsModelDelegate?
    
    /// - Parameters:
    ///   - serviceClient: An object that retrieves data for a given type from a `URL`.
    ///   - items: The items to be displayed by `PokemonDetailsViewController`.
    init(serviceClient: ServiceClient, items: [DetailsItem]) {
        self.serviceClient = serviceClient
        self.items = items
    }
    
    /// A method that notifies the model that a user selected a `DetailsItem` row.
    ///
    /// - Parameter row: The row selected by the user.
    func userTapped(_ row: Int) {
        
        // Notify the UI that a download will occur.
        delegate?.willDownload()
        
        // Locate the item selected.
        let item = items[row]
        
        // Perform a networking task to retrieve data about the selected item.
        //
        // Specify the type to be decoded while parsing the network response.
        //
        // See `PokemonDetailsModel.init` invocations for examples of the types
        // specified in this implementation.
        //
        // See `ServiceClient` for networking implementation details.
        serviceClient.get(T.self, from: item.url) { [weak self] in
            
            // Switch over the result to determine the application's
            // next course of action.
            switch $0 {
            case .success(let displayable):
                
                // Notify the UI that a successful value was received.
                self?.delegate?.received(displayable: displayable, withTitle: item.title)
                
            case .failure(let error):
                
                // Notify the UI that an `Error` was encountered.
                self?.delegate?.received(error: error)
            }
        }
    }
}
