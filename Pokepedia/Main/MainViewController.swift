import UIKit

import PokemonUIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the `UINavigationController` that will direct
        // the application's navigation flow.
        let navigationController = makePokédexViewController()
        
        // Add the `navigationController` as a child view controller
        // and constrain it to be full-screen.
        addFullscreen(navigationController)
    }
}

extension MainViewController {
    
    private func makePokédexViewController() -> UINavigationController {
        
        // Create the `ServiceClient`.
        let serviceClient = ServiceClient()
        
        // Create the menu action.
        let menuAction = ViewPokemonMovesAction(serviceClient: serviceClient)
        
        // Create the `PokédexViewController`.
        let rootViewController = PokédexViewController(menuItemActions: [menuAction])

        // Return a `UINavigationController` instance with the `PokédexViewController`
        // assuming the role of `rootViewController`.
        return UINavigationController(rootViewController: rootViewController)
    }
}
