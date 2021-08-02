import Foundation

/// Various names for a PokéAPI attribute.
///
/// See [PokéAPI documentation](https://pokeapi.co/docs/v2#type)
/// for details.
struct Name: Decodable {
    let name: String?
}
