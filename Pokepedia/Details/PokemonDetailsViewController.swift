import UIKit

import PokemonFoundation
import CommonKit

/// A `UIViewController` subclass that displays a list of `DetailsItem`s.
///
/// This view controller, when initialized, requires a generic type `T` that conforms to both `Displayable & Decodable`
/// to be specified.
///
/// The specified type is used as the guiding type to be decoded from service and
/// displayed in an additional `UIViewController` (specifically `PokemonDetailViewController`).
///
/// Due to the generic type constraints; conformances to the `UITableViewDelegate` and
/// `UITableViewDataSource` protocols __must__ be supplied in the class definition.
///
/// Consult `ViewPokemonDetailsAction` for invocation examples.
///
/// - SeeAlso: `PokemonDetailsModel`.
/// - SeeAlso: `ViewPokemonDetailsAction`.
final class PokemonDetailsViewController<T: Displayable & Decodable>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    /// An object used to block the UI while a networking task is executing.
    private lazy var activityIndicator = lazyActivityIndicator()
    
    /// The object used to display a collection of `DetailsItem`s.
    private lazy var tableView = lazyTableView()
    
    /// An object used to isolate any and all business logic pertinent to this view controller implementation.
    ///
    /// Specific responsibilities of this class include:
    /// - Maintaining a  collection of `DetailsItem`s to display.
    /// - Performing networking tasks to retrieve additional data when a `DetailsItem` is selected.
    private let model: PokemonDetailsModel<T>
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - model: The model used to isolate any and all business decisions made while this view controller is visible.
    ///   - title: The title of this view controller.
    init(model: PokemonDetailsModel<T>, title: String) {
        
        // Set the model.
        self.model = model

        // Call to `super` to initialize "self".
        super.init(nibName: nil, bundle: nil)
        
        // Set the title and the model's delegate properties.
        self.title = title
        model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        
        // Disable use of this view controller in storyboard implementations.
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add and constrain the `tableView` property.
        //
        // See `CommonKit` for `constrain(to:)` extension implementation.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.constrain(to: view)
        
        // Add and constrain the `activityIndicator` property.
        //
        // See `CommonKit` for `constrain(to:)` extension implementation.
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.constrain(to: view)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Animate deselecting the row.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Notify the model that a selection occurred.
        model.userTapped(indexPath.row)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Return the number of sections to display.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the total number of `DetailsItem`s to display.
        return model.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a `SubtitleTableViewCell`.
        //
        // See `CommonKit` for `dequeueReusableCell()` extension implementation.
        let cell: SubtitleTableViewCell = tableView.dequeueReusableCell()!
        
        // Locate the item pertinent to the "cellForRow".
        let item = model.items[indexPath.row]
        
        // Configure the cell.
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.accessoryType = .disclosureIndicator
        
        // Return the configured cell.
        return cell
    }
}

// MARK: - DetailsModelDelegate

extension PokemonDetailsViewController: DetailsModelDelegate {
    
    func willDownload() {
        
        // Ensure the `activityIndicator` begins animating on the main thread.
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func received(displayable: Displayable, withTitle title: String) {
        
        // Place UI updates on the main thread.
        DispatchQueue.main.async { [weak self] in
            
            // Ensure the `activityIndicator` stops animating.
            self?.activityIndicator.stopAnimating()
            
            // Create an instance of `PokemonDetailViewController` to display the retrieved value.
            //
            // Initializer invoked using `.init(details:,title:)` to enable quick docs (option + click).
            let viewController: PokemonDetailViewController = .init(details: displayable.details, title: title)
            
            // Show the `PokemonDetailViewController` using the `show(_:,sender:)` method, which will add
            // the `PokemonDetailViewController` to the app's `UINavigationController`'s navigation stack.
            self?.show(viewController, sender: self)
        }
    }
    
    func received(error: Error) {
        
        // Place UI updates on the main thread.
        DispatchQueue.main.async { [weak self] in
            
            // Ensure the `activityIndicator` stops animating.
            self?.activityIndicator.stopAnimating()
            
            // Create a `UIAlertController` to notify the user that an `Error` was encountered.
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            
            // Add an action to the alert so that it may be dismissed.
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // Present the `PokemonDetailViewController` using the `present(_:,animated:, completion:)`
            // method, which will present the alert modally.
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - Lazy Loading Methods

extension PokemonDetailsViewController {
    
    private func lazyActivityIndicator() -> UIActivityIndicatorView {
        
        // Create a `UIActivityIndicatorView`.
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        // Configure the `activityIndicator` to hide when it is not animating.
        activityIndicator.hidesWhenStopped = true
        
        // Return the `UIActivityIndicatorView`.
        return activityIndicator
    }
    
    private func lazyTableView() -> UITableView {
        
        // Create a `UITableView`.
        let tableView = UITableView()
        
        // Register the `SubtitleTableViewCell` class with the `tableView`.
        //
        // See `CommonKit` for `register(_:)` extension implementation.
        tableView.register(SubtitleTableViewCell.self)
        
        // Assign the `tableView`'s `delegate` and `dataSource` properties.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Return the `UITableView`.
        return tableView
    }
}
