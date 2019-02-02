
import UIKit

class SingleCommentViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
