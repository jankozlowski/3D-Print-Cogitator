
import UIKit

class SingleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    func showView(image: UIImage){
        
        print("in single cell \( image.size)")
        if(image==nil){
            print("in sv image 1 nil")
        }
        if(self.image==nil){
            print("in sv image 2 nil")
        }
        self.image.image = image;
        
        self.image.layer.cornerRadius = 20
        self.image.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if self.window != nil { return }
        
        self.image = nil
    }
}
