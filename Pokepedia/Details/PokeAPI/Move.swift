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

extension Move: Displayable {
    
    var details: [Detail] {
        [
            Detail(key: "ID", values: [id.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Name", values: [name?.capitalized ?? Detail.defaultText]),
            Detail(key: "Accuracy", values: [accuracy.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Power", values: [power.map { "\($0)" } ?? Detail.defaultText]),
            Detail(key: "Names", values: names?.compactMap { $0.name?.capitalized } ?? [Detail.defaultText])
        ]
    }
}
