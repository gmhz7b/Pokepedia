import Foundation

/// The move the Pokémon can learn.
///
/// See [PokéAPI documentation](https://pokeapi.co/docs/v2#move)
/// for details.
struct Move: Decodable {
    let id: Int?
    let name: String?
    let accuracy: Int?
    let power: Int?
    let names: [Name]?
}

extension Move {

    /// Details to be displayed about an individual `Move` instance.
    var details: [Detail] {
        [
            Detail(
                key: "ID",
                values: [id.map { "\($0)" } ?? Detail.defaultText]
            ),
            Detail(
                key: "Name",
                values: [name?.capitalized ?? Detail.defaultText]
            ),
            Detail(
                key: "Accuracy",
                values: [accuracy.map { "\($0)" } ?? Detail.defaultText]
            ),
            Detail(
                key: "Power",
                values: [power.map { "\($0)" } ?? Detail.defaultText]
            ),
            Detail(
                key: "Names",
                values: names?.compactMap { $0.name?.capitalized } ?? [Detail.defaultText]
            )
        ]
    }
}

extension Move {
    
    /// Various names for a PokéAPI attribute.
    ///
    /// See [PokéAPI documentation](https://pokeapi.co/docs/v2#type)
    /// for details.
    struct Name: Decodable {
        let name: String?
    }
    
    /// A `struct` representing a detail to be displayed.
    ///
    /// - SeeAlso: `MoveViewController`.
    struct Detail {
        let key: String
        let values: [String]
        
        /// The default text to display when a value cannot be located.
        static let defaultText = "N/A"
    }
}
