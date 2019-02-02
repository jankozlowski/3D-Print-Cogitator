
import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var search: UIButton!
    
    @IBOutlet weak var visualize: UIButton!
    @IBOutlet weak var cost: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchString = "Search for Models"
        let costString = "Cost Print"
        let visualizerString = "Visualizer"
        
        let myAttribute = [ NSAttributedString.Key.strokeColor: UIColor.white, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.strokeWidth: -1.5, ] as [NSAttributedString.Key : Any]
        let searchAttrString = NSAttributedString(string: searchString, attributes: myAttribute)
        let costAttrString = NSAttributedString(string: costString, attributes: myAttribute)
        let visualizerAttrString = NSAttributedString(string: visualizerString, attributes: myAttribute)
        
        search.setAttributedTitle(searchAttrString, for: UIControl.State.normal)
        cost.setAttributedTitle(costAttrString, for: UIControl.State.normal)
        visualize.setAttributedTitle(visualizerAttrString, for: UIControl.State.normal)
        
        
    }
    
    
}

