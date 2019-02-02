
import UIKit
import Toast_Swift
import iOSDropDown

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var modelCollection: UICollectionView!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var searchWord: UITextField!
    @IBOutlet weak var category: DropDown!
    @IBOutlet weak var subcategory: DropDown!
    @IBOutlet weak var searchThings: UIButton!
    @IBOutlet weak var border: UIImageView!
    
    var imageCache = NSCache<NSString, UIImage>()
    var pageCount = 2
    var urlToSearch = ""
    var collectionModels :[Model] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = modelCollection.dequeueReusableCell(withReuseIdentifier: "SingleViewCell", for: indexPath) as! SingleViewCell
        
        let singleModel = collectionModels[indexPath.row]
        
        let url:URL  = NSURL(string: singleModel.thumbnail!) as! URL
        
        let imageFromCache = imageCache.object(forKey: singleModel.thumbnail as! NSString)
        
        if ((imageFromCache) != nil) {
            cell.showView(image: imageFromCache!)
        }
        else{
            let img = UIImage.gif(name: "gear")
            cell.showView(image: img!)
            
            let helper:HelperFunctions = HelperFunctions()
            
            helper.getImage(from: url, completion: {
                data, response, error in
                
                self.imageCache.setObject(UIImage(data: data!)!, forKey: singleModel.thumbnail as! NSString)
                cell.showView(image: UIImage(data: data!)!)
            })
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
        let tbc = storyboard.instantiateViewController(withIdentifier: "ModelTab") as? ModelTabBarController
        
        let vc = tbc!.viewControllers?[0] as! SingleModelViewController
        vc.model = collectionModels[indexPath.row]
        self.navigationController?.pushViewController(tbc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionModels.count - 1 {
            
            self.view.makeToast("Loading new images")
            
            let defaults = UserDefaults.standard
            let accessToken = defaults.string(forKey: "AccessCode")
            
            let httpHelper:HttpHelper = HttpHelper()
            
            _ = httpHelper.httpGet(getUrl: self.urlToSearch+"?per_page=20&page="+String(pageCount)+"&access_token="+accessToken!,completionHandler: {responseString in
                
                let models = httpHelper.readSearchModels(jsonString: responseString)
                
                for mod in models{
                    self.collectionModels.append(mod);
                }
                
                self.pageCount+=1
                
                DispatchQueue.main.async {
                    self.modelCollection.reloadData()
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelCollection.register(UINib(nibName: "SingleViewCell", bundle: nil), forCellWithReuseIdentifier: "SingleViewCell")
        
        let searchString = "Search Things"
        
        let myAttribute = [ NSAttributedString.Key.strokeColor: UIColor.white, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.strokeWidth: -1.5, ] as [NSAttributedString.Key : Any]
        let searchAttrString = NSAttributedString(string: searchString, attributes: myAttribute)
       
        
        searchThings.setAttributedTitle(searchAttrString, for: UIControl.State.normal)
        
        loadingImage.image = UIImage.gif(name: "gear")
        loadingImage.isHidden = true
        border.isHidden = true
        
        
        self.searchWord.layer.cornerRadius = 10
        self.searchWord.clipsToBounds = true
        
        self.searchWord.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.searchWord.frame.height))
        self.searchWord.leftViewMode = .always
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        
        if(accessToken != nil){
            
            let httpHelper:HttpHelper = HttpHelper()
            
            _ = httpHelper.httpGet(getUrl: "https://api.thingiverse.com//categories?access_token="+accessToken!,completionHandler: {responseString in
                
                let subcategories = httpHelper.readCategories(jsonString: responseString)
                var subcategoriesArray = [String]()
                subcategoriesArray.append("All")
                
                for cat in subcategories{
                    subcategoriesArray.append(cat.name!)
                }
                
                self.subcategory.optionArray = subcategoriesArray
                
                let categoryArray = ["All","Newest","Popular","Featured","Verified"]
                self.category.optionArray = categoryArray
                
                self.subcategory.selectedIndex = 0
                self.category.selectedIndex = 0
                
                self.subcategory.didSelect{(selectedText , index ,id) in
                    
                    if(selectedText != "All"){
                        self.searchWord.text = ""
                        self.searchWord.isUserInteractionEnabled = false
                        self.searchWord.isEnabled = false
                        
                        if(self.category.text == "All"){
                            self.category.selectedIndex = 1
                            self.category.text = "Newest"
                        }
                    }
                    else if(selectedText == "All" && self.category.text == "All"){
                        self.searchWord.isUserInteractionEnabled = true
                        self.searchWord.isEnabled = true
                        
                    }
                }
                
                self.category.didSelect{(selectedText , index ,id) in
                    
                    if(selectedText != "All"){
                        self.searchWord.text = ""
                        self.searchWord.isUserInteractionEnabled = false
                        self.searchWord.isEnabled = false
                    }
                    else if(selectedText == "All"){
                        self.subcategory.selectedIndex = 0
                        self.subcategory.text = "All"
                        self.searchWord.isUserInteractionEnabled = true
                        self.searchWord.isEnabled = true
                    }
                    
                }
                
            })
        }
        
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        
        self.pageCount = 2
        
        DispatchQueue.main.async {
            self.loadingImage.isHidden = false
            self.border.isHidden = false
        }
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        if(accessToken==nil){
            DispatchQueue.main.async {
                self.loadingImage.isHidden = true
                self.border.isHidden = true
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebView")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let httpHelper:HttpHelper = HttpHelper()
            
            var stringUrl = ""
            
            if(category.text == "All" && subcategory.text == "All" && self.searchWord.text == ""){
                self.view.makeToast("No query or category selected")
                DispatchQueue.main.async {
                    self.loadingImage.isHidden = true
                    self.border.isHidden = true
                }
            }
            else if(category.text == "All" && subcategory.text == "All" && self.searchWord.text != ""){
                stringUrl = "https://api.thingiverse.com/search/"+self.searchWord.text!
            }
            else if(category.text == "All" && subcategory.text != "All"){
                self.view.makeToast("Parent categor not selected")
            }
            else if(category.text != "All" && subcategory.text == "All"){
                stringUrl = "https://api.thingiverse.com/"+category.text!
            }
            else if(category.text != "All" && subcategory.text != "All"){
                stringUrl = "https://api.thingiverse.com/"+category.text!+"/"+subcategory.text!
            }
            
            stringUrl = stringUrl.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
            
            urlToSearch = stringUrl
            
            print(stringUrl)
            
            _ = httpHelper.httpGet(getUrl: stringUrl + "?per_page=20&access_token="+accessToken!,completionHandler: {responseString in
                
                let models = httpHelper.readSearchModels(jsonString: responseString)
                self.collectionModels = models
                
                DispatchQueue.main.async {
                    // self.testImage.image = #imageLiteral(resourceName: "testImage2")
                    self.modelCollection.reloadData()
                    self.loadingImage.isHidden = true
                    self.border.isHidden = true
                }
            })
        }
    }
    
}
