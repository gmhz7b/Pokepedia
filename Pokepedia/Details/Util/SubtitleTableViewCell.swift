import UIKit

/// A `UITableViewCell` subclass that utilizes the `subtitle` style.
final class SubtitleTableViewCell: UITableViewCell {
    
    /// The identifier used in congruence with registering and dequeueing a cell.
    static let reuseIdentifier: String = "\(type(of: SubtitleTableViewCell.self))"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
