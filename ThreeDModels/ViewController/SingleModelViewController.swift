
import UIKit
import ImageSlideshow
import SwiftGifOrigin
import Toast_Swift


extension UIImage{
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 20
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

class SingleModelViewController: UIViewController {
    
    var model:Model?
    var fullModel:FullModel?
    var images:[ModelImage]?
    var downloadedImages = [Data]()
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var viewContiner: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fileCountLabel: UILabel!
    @IBOutlet weak var addDateLabel: UILabel!
    @IBOutlet weak var viewCountLable: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var collectionCountLabel: UILabel!
    @IBOutlet weak var downloadCountLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var descripctionLabel: UILabel!
    
    @IBOutlet weak var containerHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    
    @IBAction func downloadButton(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
        }
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        let httpHelper:HttpHelper = HttpHelper()
        _ = httpHelper.httpGet(getUrl: "https://api.thingiverse.com/things/"+String(describing: self.model!.id!)+"/package-url?access_token="+accessToken!,completionHandler: {responseString in
            
            print(responseString)
            
            let zip = httpHelper.readModelZipPackage(jsonString: responseString)
            let url = URL(string: zip.publicUrl!)
            
            print(self.model!.name!)
            
            httpHelper.loadFileAsync(url: url!, name: self.model!.name!+".zip", completion: { response, error in
                
                print("download complet")
                
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                    self.view.makeToast("Download complet")
                }
            })
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadingView.image = UIImage.gif(name: "gear2")
        
        idLabel.text = String(describing: (model?.name)!)
        nameLabel.text = model?.name
        
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.contentSize = CGSize(width: 320, height: 1500)
        scrollView.isUserInteractionEnabled = true
        
        let img = UIImage.gif(name: "gear2")
        
        var imagesInputs = [InputSource]()
        imagesInputs.append(ImageSource(image: img!))
        self.imageSlideshow.setImageInputs(imagesInputs)
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        print("Acess Token " + accessToken!)
        let httpHelper:HttpHelper = HttpHelper()
        _ = httpHelper.httpGet(getUrl: "https://api.thingiverse.com/things/"+String(describing: (model?.id)!)+"/?access_token="+accessToken!,completionHandler: {responseString in
            
            self.fullModel = httpHelper.readFullSingleModel(jsonString: responseString)
            
            DispatchQueue.main.async {
                self.idLabel.text = (self.fullModel?.name!)!
                self.nameLabel.text = (self.fullModel?.creator!.name!)!
                
                self.addDateLabel.text = "Add Date: " + (self.fullModel?.addDate!)!
                
                self.collectionCountLabel.text = "Collection Count: " + String((self.fullModel?.collect_count!)!)
                
                self.downloadCountLabel.text = "Download Count: " + String((self.fullModel?.download_count!)!)
                
                self.fileCountLabel.text = "File Count: " + String((self.fullModel?.file_count!)!)
                
                self.licenseLabel.text = "License: " + (self.fullModel?.license!)!
                
                self.descripctionLabel.text = (self.fullModel?.model_description!)!
                
                self.likeCountLabel.text = "Like Count: " + String((self.fullModel?.like_count!)!)
                
                self.viewCountLable.text = "View Count: " + String((self.fullModel?.view_count!)!)

                let font = UIFont(name: "System", size: 16.0)
                self.descripctionLabel.numberOfLines = 0
                self.descripctionLabel.lineBreakMode = .byWordWrapping
                self.descripctionLabel.font = font
                self.descripctionLabel.sizeToFit()
                
                self.containerHeightConstrain.constant = self.descripctionLabel.frame.height + 800
                
                self.loadingView.isHidden = true
            }
 
            self.resolveAfterLoop(accessToken: accessToken!, fullModel: self.fullModel!, completionHandler:
                {
                    var imagesInputs = [InputSource]()
                    
                    for im in self.downloadedImages{
                        print(im)
                        let img = UIImage(data: im)!
                        imagesInputs.append(ImageSource(image: img))
                    }
                    DispatchQueue.main.async {
                        self.imageSlideshow.setImageInputs(imagesInputs)
                        
                        let items = self.imageSlideshow.slideshowItems
                        
                        for it in items {
                            it.imageView.image = it.imageView.image!.roundedImage
                        }
                      
                    }
            })
        })
    }
    
    func resolveAfterLoop(accessToken: String,fullModel: FullModel, completionHandler: @escaping () -> ()) {
        
        let httpHelper:HttpHelper = HttpHelper()
        httpHelper.httpGet(getUrl: (fullModel.images_url!)+"/?access_token="+accessToken,completionHandler: {responseString in
            
            self.images = httpHelper.readModelImages(jsonString: responseString) 
            
            let helper:HelperFunctions = HelperFunctions()
            
            for image in self.images!{
                
                
                let url:URL = URL(string: image.sizes![0].url!)!
                
                helper.getImage(from: url, completion: {
                    data, response, error in
                    
                    var backToString = String(data: data!, encoding: String.Encoding.utf8) as String!
                    self.downloadedImages.append(data!)
                    completionHandler()
                })
            }
        })
    }
}
