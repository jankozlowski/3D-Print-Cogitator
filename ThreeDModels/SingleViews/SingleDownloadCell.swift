
import UIKit

protocol SingleDownloadCellDelegate{
    
    func downloadSelectedFile(url: String, name: String)
    
}

class SingleDownloadCell: UITableViewCell {
    
    var name: String?
    var downloadUrl: String?
    var delegate: SingleDownloadCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func fileDownloadClicked(_ sender: Any) {
        delegate?.downloadSelectedFile(url: downloadUrl!, name: name!)
    }
}
