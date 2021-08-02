import UIKit

import PokemonFoundation
import CommonKit

/// A `UITableViewController` subclass that displays a collection of `Detail`s
/// supplied by an object conforming to the `Displayable` protocol.
///
/// A `UITableViewController` is a `UIViewController` subclass that provides:
/// - A `UITableView` constrained to be full-screen.
/// - Automatic conformance to the `UITableViewDelegate` and `UITableViewDataSource` protocols.
///
/// - SeeAlso: `Detail`.
/// - SeeAlso: `Displayable`.
/// - SeeAlso: `PokemonDetailsViewController`.
final class PokemonDetailViewController: UITableViewController {
    
    // MARK: - Properties
        
    private let details: [Detail]
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - details: The collection of `Detail`s to be displayed.
    ///   - title: The title of this view controller.
    init(details: [Detail], title: String) {
        
        // Set the details.
        self.details = details
        
        // Call to `super` to initialize "self".
        super.init(nibName: nil, bundle: nil)
        
        // Set the title property.
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        
        // Disable use of this view controller in storyboard implementations.
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle Methods

extension PokemonDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable selection in the `tableView`.
        tableView.allowsSelection = false
        
        // Register the `UITableViewCell` class with the `tableView`.
        //
        // See `CommonKit` for `register(_:)` extension implementation.
        tableView.register(UITableViewCell.self)
    }
}

// MARK: - UITableViewDataSource

// NOTE: - `override` keywords must be supplied as `UITableViewController` subclasses
// automatically conform to the `UITableViewDelegate` and `UITableViewDataSource` protocols.

extension PokemonDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Return the number of sections to display.
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the total number of `Detail`s to display for each section.
        return details[section].values.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // Return the title for each section.
        return details[section].key
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a `UITableViewCell`.
        //
        // See `CommonKit` for `dequeueReusableCell()` extension implementation.
        let cell: UITableViewCell = tableView.dequeueReusableCell()!
        
        // Locate the value pertinent to the `indexPath`.
        let value = details[indexPath.section].values[indexPath.row]
        
        // Configure the cell.
        cell.textLabel?.text = value
        
        // Return the configured cell.
        return cell
    }
}
