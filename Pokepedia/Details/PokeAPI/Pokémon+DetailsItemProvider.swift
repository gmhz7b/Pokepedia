import PokemonFoundation

// MARK: - Pokémon Attribute DetailsItemProvider Conformances

// The following extensions add `DetailsItemProvider` conformance
// on to various `Pokémon` list attributes.
//
// For each extension:
// - A title, detail, and url are extracted from the object.
// - The extracted properties are used to initialize and
// return a `DetailsItem`.
//
// If at least one of the three properties mentioned above cannot
// be extracted; the implementation returns `nil`.

extension Pokémon.Ability: DetailsItemProvider {
    
    var detailsItem: DetailsItem? {
        guard
            let title = ability?.name?.capitalized,
            let detail = slot,
            let url = ability?.url
        else {
            return nil
        }
        
        return DetailsItem(title: title, detail: "Slot #\(detail)", url: url)
    }
}

extension Pokémon.Move: DetailsItemProvider {
    
    var detailsItem: DetailsItem? {
        guard
            let title = move?.name?.capitalized,
            let detail = versionGroupDetails?.first?.moveLearnMethod?.name,
            let url = move?.url
        else {
            return nil
        }
        
        return DetailsItem(title: title, detail: "Learned by \(detail)", url: url)
    }
}

extension Pokémon.Stat: DetailsItemProvider {
    
    var detailsItem: DetailsItem? {
        guard
            let title = stat?.name?.capitalized,
            let detail = baseStat,
            let url = stat?.url
        else {
            return nil
        }
        
        return DetailsItem(title: title, detail: "Base value \(detail)", url: url)
    }
}

extension Pokémon.`Type`: DetailsItemProvider {
    
    var detailsItem: DetailsItem? {
        guard
            let title = type?.name?.capitalized,
            let detail = slot,
            let url = type?.url
        else {
            return nil
        }
        
        return DetailsItem(title: title, detail: "Slot #\(detail)", url: url)
    }
}
