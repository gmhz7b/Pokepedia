import Foundation

import PokemonFoundation

/// The ability the Pokémon may have
///
/// See [PokéAPI documentation](https://pokeapi.co/docs/v2#ability)
/// for details.
struct Ability: Decodable {
    let id: Int?
    let name: String?
    let isMainSeries: Bool?
    let generation: NamedAPIResource?
    let names: [Name]?
}

extension Ability: Displayable {
    
    var details: [Detail] {
        [
            Detail(key: "ID", values: [id.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Name", values: [name?.capitalized ?? Detail.defaultText]),
            Detail(key: "Is Main Series", values: [isMainSeries.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Generation", values: [(generation?.name).map { "\($0.capitalized)" } ?? Detail.defaultText]),
            Detail(key: "Names", values: names?.compactMap { $0.name?.capitalized } ?? [Detail.defaultText])
        ]
    }
}
