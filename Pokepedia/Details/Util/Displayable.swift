import Foundation

import PokemonFoundation

/// A `protocol` representing a displayable object.
///
/// - SeeAlso: `PokemonDetailsViewController`.
protocol Displayable {
    
    /// The array of `Detail`s to be displayed.
    ///
    /// - SeeAlso: `Detail`.
    /// - SeeAlso: `PokemonDetailViewController`.
    var details: [Detail] { get }    
}

/// A `struct` representing a detail to be displayed.
///
/// - SeeAlso: `PokemonDetailViewController`.
struct Detail {
    let key: String
    let values: [String]
    
    /// The default text to display when a value cannot be located.
    static let defaultText = "N/A"
}
