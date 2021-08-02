import Foundation

import PokemonFoundation

/// An `enum` representing an attribute of a `Pokémon` to be displayed by a `ViewPokemonDetailsAction`.
///
/// - SeeAlso: `ViewPokemonDetailsAction`.
enum DetailsOption: String, CaseIterable {
    case abilities
    case moves
    case stats
    case types
    
    /// The title of the option.
    var title: String { rawValue.capitalized }
    
    /// A string representing the SF symbol for a given option.
    var systemImageName: String {
        switch self {
        case .abilities:
            return "burst.fill"
            
        case .moves:
            return "figure.walk"
            
        case .stats:
            return "chart.bar.xaxis"
            
        case .types:
            return "atom"
        }
    }
}
