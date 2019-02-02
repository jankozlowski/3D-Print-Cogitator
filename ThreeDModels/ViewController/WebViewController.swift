
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redirectUrl = URL(string: "https://www.thingiverse.com/login/oauth/authorize?client_id=454b378dfdf480e2d2f5")
        
        self.webView.load(URLRequest(url: redirectUrl!))
        
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === self.webView && keyPath == "URL" {
            print(webView.url!)
            if(webView.url!.absoluteString.contains("code")){
                
                var code = "";
                let linkWithCode = webView.url!.absoluteString
                
                let codePosition = linkWithCode.distance(from: linkWithCode.startIndex, to: (linkWithCode.range(of: "code=")?.upperBound)!)
                
                let range = linkWithCode.index(linkWithCode.startIndex, offsetBy: codePosition)..<linkWithCode.endIndex
                
                code = String(linkWithCode[range])
                
                print(code)
                
                let httpHelper:HttpHelper = HttpHelper()
                
                httpHelper.httpPostAccessToken(postUrl: "https://www.thingiverse.com/login/oauth/access_token?client_id=454b378dfdf480e2d2f5&client_secret=65d447d8abd3f483471544ac02e0301f&code="+code)
                
                // self.dismiss(animated: true, completion: nil)
                let root = UIApplication.shared.keyWindow?.rootViewController
                root?.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    
}
