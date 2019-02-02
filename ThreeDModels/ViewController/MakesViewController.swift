
import UIKit

class MakesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allMakes = [ModelMake]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        print(screenHeight)
        
        tableView.estimatedRowHeight = screenHeight
        tableView.rowHeight = screenHeight-64
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleMakeCell", for: indexPath)
            as! SingleMakeCell
        
        cell.makeImage.image = UIImage.gif(name: "gear")
        cell.makeImage.contentMode = .scaleAspectFit
        
        let url = URL(string: allMakes[indexPath.row].makeSizes![0].sizes![12].url!)
        
        let helper = HelperFunctions()
        
        helper.getImage(from: url!,completion: {data, response, error in
            
            DispatchQueue.main.async {
                cell.makeImage.contentMode = .scaleAspectFill
                cell.makeImage.image = UIImage(data: data!)
            }
            
            
        })
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage.gif(name: "gear")
        loadingImage.image = img!
        
        let fullModel = (self.tabBarController!.viewControllers![0] as! SingleModelViewController).fullModel
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        let httpHelper:HttpHelper = HttpHelper()
        _ = httpHelper.httpGet(getUrl: "https://api.thingiverse.com/things/"+String(describing:fullModel!.id!)+"/copies?access_token="+accessToken!,completionHandler: {responseString in
            
            let makes = httpHelper.readModelMakes(jsonString: responseString)
            
            var i=0;
            for make in makes{
                
                httpHelper.httpGet(getUrl: make.images_url! + "?access_token=" + accessToken!,completionHandler: {responseString in
                    print(responseString)
                    
                    make.makeSizes =  httpHelper.readModelMakeSizes(jsonString: responseString)
                    
                    i = i+1
                    if(i==makes.count){
                        DispatchQueue.main.async {
                            self.allMakes = makes
                            self.tableView.reloadData()
                            self.loadingImage.isHidden = true
                        }
                    }
                })
            }
            if(makes.count==0){
                DispatchQueue.main.async {
                    self.loadingImage.isHidden = true
                }
            }
        })
    }
}
