import Foundation

/// The stat the Pokémon has.
///
/// See [PokéAPI documentation](https://pokeapi.co/docs/v2#stat)
/// for details.
struct Stat: Decodable {
    let id: Int?
    let name: String?
    let gameIndex: Int?
    let isBattleOnly: Bool?
    let names: [Name]?
}

extension Stat: Displayable {
    
    var details: [Detail] {
        [
            Detail(key: "ID", values: [id.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Name", values: [name?.capitalized ?? Detail.defaultText]),
            Detail(key: "Game Index", values: [gameIndex.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Is Battle Only", values: [isBattleOnly.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Names", values: names?.compactMap { $0.name?.capitalized } ?? [Detail.defaultText])
        ]
    }
}
