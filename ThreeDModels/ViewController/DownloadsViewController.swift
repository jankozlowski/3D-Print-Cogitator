import UIKit
import Toast_Swift

class DownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SingleDownloadCellDelegate {
    
    
    func downloadSelectedFile(url: String, name: String) {
        
        DispatchQueue.main.async {
            self.loadingImage.isHidden = false
        }
        
        let urlToSend = URL(string: url)
        
        let httpHelper = HttpHelper()
        httpHelper.loadFileAsync(url: urlToSend!, name: name, completion: { response, error in
            
            DispatchQueue.main.async {
                self.loadingImage.isHidden = true
                self.view.makeToast("Download complet")
            }
        })
        
    }
    
    var downloadList = [ModelFile]()
    
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //   tableView.register(UINib(nibName: "SingleDownloadCell", bundle: nil), forCellReuseIdentifier: "MySingleDownloadCell")
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySingleDownloadCell", for: indexPath)
            as! SingleDownloadCell
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let sizeLabel = cell.viewWithTag(2) as! UILabel
        let dateLabel = cell.viewWithTag(3) as! UILabel
        let downloadsLabel = cell.viewWithTag(4) as! UILabel
        let smallImage = cell.viewWithTag(5) as! UIImageView
        
        cell.delegate = self
        
        let download = downloadList[indexPath.row]
        
        cell.downloadUrl = download.public_url!
        
        print(download.public_url!)
        cell.name = download.name
        
        dateLabel.text = download.date!
        downloadsLabel.text = "Downloads: " + String(describing: download.download_count!)
        nameLabel.text = download.name
        sizeLabel.text = "Size: " + String(describing: download.size!) + " Kb"
        
        smallImage.image = UIImage.gif(name: "gear")!
        
        if(download.default_image?.sizes?[0].url != nil){
            let url = URL(string: download.default_image!.sizes![0].url!)
            
            let helper = HelperFunctions()
            
            helper.getImage(from: url!, completion: {
                data, response, error in
                DispatchQueue.main.async {
                    smallImage.image = UIImage(data: data!)!
                }
                
            })
        }
        else{
            DispatchQueue.main.async {
                smallImage.image = #imageLiteral(resourceName: "ImageLost")
            }
        }
        //   cell.smallImage?.image = UIImage(named: download.default_image.)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage.gif(name: "gear2")
        
        loadingImage.image = img!
        
        let fullModel = (self.tabBarController!.viewControllers![0] as! SingleModelViewController).fullModel
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        let httpHelper:HttpHelper = HttpHelper()
        _ = httpHelper.httpGet(getUrl: (fullModel?.files_url!)!+"?access_token="+accessToken!,completionHandler: {responseString in
            
            print(responseString)
            
            let files = httpHelper.readModelFiles(jsonString: responseString)
            
            self.downloadList = files
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadingImage.isHidden = true
                print(self.downloadList.count)
            }
            
        })
        
    }
}
