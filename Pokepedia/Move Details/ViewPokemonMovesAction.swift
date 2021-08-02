import UIKit

import PokemonFoundation
import PokemonUIKit

/// An implementation of `PokédexMenuItemAction` that displays a given `Pokémon`'s `moves` attributes.
final class ViewPokemonMovesAction: PokédexMenuItemAction {
    
    private let serviceClient: ServiceClient
    
    var title: String { "View Moves" }
    var image: UIImage? { UIImage(systemName: "figure.walk") }
    
    /// - Parameters:
    ///   - serviceClient: An object that retrieves data for a given type from a `URL`.
    init(serviceClient: ServiceClient) {
        self.serviceClient = serviceClient
    }
}

extension ViewPokemonMovesAction {
    
    func viewController(for pokémon: Pokémon) -> UIViewController {
        
        // Create the items.
        //
        // Provide an empty array default value.
        let items = items(from: pokémon.moves ?? [])
        
        // Create the model.
        //
        // Initializer invoked using `.init(serviceClient:,items:)` to enable quick docs (option + click).
        let model: MovesModel = .init(serviceClient: serviceClient, items: items)
        
        // Create an instance of `MovesViewController`.
        //
        // Initializer invoked using `.init(model:)` to enable quick docs (option + click).
        let viewController: MovesViewController = .init(model: model)
        
        // Return the instance of `MovesViewController`.
        return viewController
    }
}

extension ViewPokemonMovesAction {
 
    /// A method that provides an array of `[MovesModel.Item]` mapped from a collection of `Pokémon.Move`.
    private func items(from moves: [Pokémon.Move]) -> [MovesModel.Item] {
        
        // `compactMap` over each element.
        return moves.compactMap {
            
            // Extract a title, detail and url.
            guard
                let title = $0.move?.name?.capitalized,
                let detail = $0.versionGroupDetails?.first?.moveLearnMethod?.name,
                let url = $0.move?.url
            else {
                
                // Swallow any elements that cannot produce a title, detail and url.
                return nil
            }
            
            // Return a `MovesModel.Item` using the extracted title, detail and url.
            return MovesModel.Item(title: title, detail: "Learned by \(detail)", url: url)
        }
    }
}
