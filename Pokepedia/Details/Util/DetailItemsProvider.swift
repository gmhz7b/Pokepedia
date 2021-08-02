import Foundation

import PokemonFoundation

/// A `protocol` representing an object that _has_ a `DetailsItem`.
///
/// - SeeAlso: `DetailsItem`.
protocol DetailsItemProvider {
    
    /// The `DetailsItem` supplied by the object implementing
    /// the `DetailsItemProvider` protocol conformance.
    ///
    /// - SeeAlso: `PokemonDetailsViewController`.
    var detailsItem: DetailsItem? { get }
}

/// A `struct` representing an item to be displayed in `PokemonDetailsViewController`.
///
/// - SeeAlso: `PokemonDetailsViewController`.
struct DetailsItem {
    let title: String
    let detail: String
    let url: URL
}
