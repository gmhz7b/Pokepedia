import UIKit

import PokemonUIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationController = makePokédexViewController()
        addFullscreen(navigationController)
    }
}

extension MainViewController {
    
    private func makePokédexViewController() -> UINavigationController {

        return UINavigationController(
            rootViewController: PokédexViewController(
                menuItemActions: [
                // TODO: - Add custom `PokédexMenuItemAction`s here.
                ]
            )
        )
    }
}
