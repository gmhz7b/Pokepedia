import Foundation

import PokemonFoundation

/// The type the referenced Pokémon has.
///
/// See [PokéAPI documentation](https://pokeapi.co/docs/v2#type)
/// for details.
struct `Type`: Decodable {
    let id: Int?
    let name: String?
    let generation: NamedAPIResource?
    let moveDamageClass: NamedAPIResource?
    let names: [Name]?
}

extension `Type`: Displayable {

    var details: [Detail] {
        [
            Detail(key: "ID", values: [id.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Name", values: [name?.capitalized ?? Detail.defaultText]),
            Detail(key: "Generation", values: [(generation?.name?.capitalized).map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Move Damage Class", values: [(moveDamageClass?.name?.capitalized).map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Names", values: names?.compactMap { $0.name?.capitalized } ?? [Detail.defaultText])
        ]
    }
}
