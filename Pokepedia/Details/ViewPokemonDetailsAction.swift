import UIKit

import PokemonFoundation
import PokemonUIKit

/// An implementation of `PokédexMenuItemAction` that takes in a `DetailsOption` to display.
final class ViewPokemonDetailsAction: PokédexMenuItemAction {
    
    private let serviceClient: ServiceClient
    private let option: DetailsOption
    
    var title: String { "View \(option.title)" }
    var image: UIImage? { UIImage(systemName: option.systemImageName) }
    
    /// - Parameters:
    ///   - serviceClient: An object that retrieves data for a given type from a `URL`.
    ///   - option: The option to be displayed by the action.
    init(serviceClient: ServiceClient, option: DetailsOption) {
        self.serviceClient = serviceClient
        self.option = option
    }
}

extension ViewPokemonDetailsAction {
    
    func viewController(for pokémon: Pokémon) -> UIViewController {
        
        // Switch over the option to determine:
        // - The type to decode from service.
        // - The attribute to pass in to the `PokemonDetailsViewController`.
        switch option {
        case .abilities:
            return detailsViewController(forType: Ability.self, using: pokémon.abilities)
            
        case .moves:
            return detailsViewController(forType: Move.self, using: pokémon.moves)
            
        case .stats:
            return detailsViewController(forType: Stat.self, using: pokémon.stats)
            
        case .types:
            return detailsViewController(forType: `Type`.self, using: pokémon.types)
        }
    }
}

extension ViewPokemonDetailsAction {
    
    /// Creates an instance of `PokemonDetailsViewController`.
    ///
    /// This method, when called, requires a generic type `T` that conforms to both `Displayable & Decodable`
    /// to be specified.
    ///
    /// The specified type is used as the guiding type to be decoded from service and
    /// displayed in an additional `UIViewController` (specifically `PokemonDetailViewController`).
    ///
    /// Consult the implementation of `viewController(for:)` for invocation examples.
    ///
    /// - Parameters:
    ///   - type: The type to be retrieved by `serviceClient` when a user
    ///   selects an item in the `PokemonDetailsViewController`'s list.
    ///   - providers: An array of `DetailsItemProvider` from which to
    ///   extract the `DetailsItem`s to be displayed.
    func detailsViewController<T: Displayable & Decodable>(
        forType type: T.Type,
        using providers: [DetailsItemProvider]?
    ) -> PokemonDetailsViewController<T> {
        
        // Create the items.
        //
        // Swallow any elements that cannot produce a `DetailsItem`.
        //
        // Provide an empty array default value.
        let items = providers?.compactMap { $0.detailsItem } ?? []
        
        // Create the model.
        //
        // Include the generic `T` type to satisfy `PokemonDetailsViewController`'s
        // generic type constraints.
        //
        // Initializer invoked using `.init(serviceClient:,items:)` to enable quick docs (option + click).
        let model: PokemonDetailsModel<T> = .init(serviceClient: serviceClient, items: items)
        
        // Return an instance of `PokemonDetailsViewController`.
        //
        // Generic `T` type constraints implicitly defined by method return value.
        //
        // Initializer invoked using `.init(model:,title:)` to enable quick docs (option + click).
        return .init(model: model, title: option.title)
    }
}
