

import UIKit
import SwiftSoup


class CostResultsViewController: UIViewController {
    
    var resultElements: Elements!
    
    @IBOutlet weak var curaCostLabel: UILabel!
    @IBOutlet weak var curaCostLabel2: UILabel!
    @IBOutlet weak var curaTimeLabel: UILabel!
    @IBOutlet weak var curaTimeLabel2: UILabel!
    @IBOutlet weak var curaMaterialLabel: UILabel!
    
    @IBOutlet weak var kissCostLabel: UILabel!
    @IBOutlet weak var kissCostLabel2: UILabel!
    @IBOutlet weak var kissTimeLabel: UILabel!
    @IBOutlet weak var kissTimeLabel2: UILabel!
    @IBOutlet weak var kissMaterialLabel: UILabel!
    
    @IBOutlet weak var slicerCostLabel: UILabel!
    @IBOutlet weak var slicerCostLabel2: UILabel!
    @IBOutlet weak var slicerTimeLabel: UILabel!
    @IBOutlet weak var slicerTimeLabel2: UILabel!
    @IBOutlet weak var slicerMaterialLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for element in resultElements{
            do{
                if(try element.outerHtml().contains("Cura")){
                    readHtmlDataAndSetUI(element: element, costLabel1: curaCostLabel, costLabel2: curaCostLabel2, timeLabel1: curaTimeLabel, timeLabel2: curaTimeLabel2, materialLabel1: curaMaterialLabel)
                }
                else if(try element.outerHtml().contains("KISSlicer")){
                    readHtmlDataAndSetUI(element: element, costLabel1: kissCostLabel, costLabel2: kissCostLabel2, timeLabel1: kissTimeLabel, timeLabel2: kissTimeLabel2, materialLabel1: kissMaterialLabel)
                }
                else if(try element.outerHtml().contains("Slic3r")){
                    readHtmlDataAndSetUI(element: element, costLabel1: slicerCostLabel, costLabel2: slicerCostLabel2, timeLabel1: slicerTimeLabel, timeLabel2: slicerTimeLabel2, materialLabel1: slicerMaterialLabel)
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    func readHtmlDataAndSetUI(element: Element, costLabel1: UILabel, costLabel2: UILabel, timeLabel1: UILabel, timeLabel2: UILabel, materialLabel1: UILabel){
        
        do{
            let table = try element.select("table").get(0)
            let trs = try table.select("tr")
            
            var i = 0
            for tr in trs{
                let td =  try tr.select("td")
                
                let target = td.get(1)
                
                if(i==0){
                    let costs = try target.select("font")
                    
                    let cost1 = costs.get(0).ownText()
                    let cost2 = costs.get(1).ownText()
                    
                    costLabel1.text = cost1
                    costLabel2.text = cost2
                }
                else if(i==1){
                    let time1 = target.ownText()
                    let timefont = try target.select("font")
                    let time2 = timefont.get(0).ownText()
                    
                    timeLabel1.text = time1
                    timeLabel2.text = time2
                }
                else{
                    let material = target.ownText()
                    materialLabel1.text = material
                }
                
                i = i+1
            }
        } catch{
            print(error)
        }
    }
}
