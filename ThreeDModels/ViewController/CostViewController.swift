
import UIKit
import MobileCoreServices
import ModelIO
import SceneKit
import SceneKit.ModelIO
import FileBrowser
import SwiftSoup
import Toast_Swift

extension String {
    var isFloat: Bool {
        return Float(self) != nil
    }
}

class CostViewController: UIViewController {
    
    var scene: SCNScene?
    var node: SCNNode?
    var filePath: URL?
    var curaSelected = true
    var kissSelected = true
    var slicerSelected = true
    var resultElements = Elements()
    
    @IBOutlet weak var sceanView: SCNView!
    @IBOutlet weak var layerHeightLabel: UILabel!
    @IBOutlet weak var infillPercentageLabel: UILabel!
    @IBOutlet weak var printSpeedLabel: UILabel!
    @IBOutlet weak var pricePerHourLabel: UILabel!
    @IBOutlet weak var pricePerGramLabel: UILabel!
    @IBOutlet weak var infillPercantageText: UILabel!
    @IBOutlet weak var printSpeedText1: UILabel!
    @IBOutlet weak var printSpeedText2: UILabel!
    @IBOutlet weak var layerHeightText: UILabel!
    @IBOutlet weak var USDHourText: UILabel!
    @IBOutlet weak var USDGramText: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var slicerLabel: UILabel!
    
    @IBOutlet weak var layerHeightEditText: UITextField!
    @IBOutlet weak var infillPerchentageEditText: UITextField!
    @IBOutlet weak var PrintSpeedEditText: UITextField!
    @IBOutlet weak var USHourEditText: UITextField!
    @IBOutlet weak var USDGramEditText: UITextField!
    @IBOutlet weak var PlaAbsRadio: UISegmentedControl!
    
    @IBOutlet weak var CuraSlicerButton: UIButton!
    @IBOutlet weak var KissSlicerButton: UIButton!
    @IBOutlet weak var Slic3rSlicerButton: UIButton!
    @IBOutlet weak var loadingImage: UIImageView!
    
    @IBOutlet weak var calculateCostButtonOutlet: UIButton!
    
    @IBAction func toggleCuraButton(_ sender: Any) {
        if(curaSelected){
            CuraSlicerButton.setImage(UIImage(named: "cura off"), for: .normal)
            CuraSlicerButton.setImage(UIImage(named:"cura off"), for: .selected)
            curaSelected = false
        }
        else{
            CuraSlicerButton.setImage(UIImage(named: "cura"), for: .normal)
            CuraSlicerButton.setImage(UIImage(named:"cura"), for: .selected)
            curaSelected = true
        }
    }
    @IBAction func toggleKissButton(_ sender: Any) {
        if(kissSelected){
            KissSlicerButton.setImage(UIImage(named: "kiss off"), for: .normal)
            KissSlicerButton.setImage(UIImage(named:"kiss off"), for: .selected)
            kissSelected = false
        }
        else{
            KissSlicerButton.setImage(UIImage(named: "kiss"), for: .normal)
            KissSlicerButton.setImage(UIImage(named:"kiss"), for: .selected)
            kissSelected = true
        }
    }
    @IBAction func toggleSlic3rButton(_ sender: Any) {
        if(slicerSelected){
            Slic3rSlicerButton.setImage(UIImage(named: "slicer off"), for: .normal)
            Slic3rSlicerButton.setImage(UIImage(named:"slicer off"), for: .selected)
            slicerSelected = false
        }
        else{
            Slic3rSlicerButton.setImage(UIImage(named: "slicer"), for: .normal)
            Slic3rSlicerButton.setImage(UIImage(named:"slicer"), for: .selected)
            slicerSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = SCNScene()
        self.node = SCNNode()
        scene!.rootNode.addChildNode(self.node!)
        
        sceanView.autoenablesDefaultLighting = true
        sceanView.allowsCameraControl = true
        sceanView.scene = scene
        sceanView.backgroundColor = UIColor.darkGray
        
        makeEditTextLeftMargin(textField: self.layerHeightEditText)
        makeEditTextLeftMargin(textField: self.infillPerchentageEditText)
        makeEditTextLeftMargin(textField: self.PrintSpeedEditText)
        makeEditTextLeftMargin(textField: self.USHourEditText)
        makeEditTextLeftMargin(textField: self.USDGramEditText)
        
    }
    
    func makeEditTextLeftMargin(textField: UITextField){
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        
        var customPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let url = URL(string: customPath[0])
        
        let fileBrowser = FileBrowser(initialPath: url)
        present(fileBrowser, animated: true, completion: nil)
        
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            
            let asset = MDLAsset(url:file.filePath)
            self.filePath = file.filePath
            
            guard let object = asset.object(at: 0) as? MDLMesh else {
                fatalError("Failed to get mesh from asset.")
            }
            
            self.scene = SCNScene()
            self.node = SCNNode(mdlObject: object)
            self.scene!.rootNode.addChildNode(self.node!)
            self.sceanView.scene = self.scene
            
            let (minVec, maxVec) = self.node!.boundingBox
            self.node!.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)
            
            let action = SCNAction.rotateBy(x: 0, y: 0.2, z: 0, duration: 0.5)
            self.scene!.rootNode.runAction(SCNAction.repeatForever(action))
            
        }
    }
    
    @IBAction func uplaodButton(_ sender: Any) {
        
        var slicer = [String]()
        if(curaSelected){
            slicer.append("Cura")
        }
        if(kissSelected){
            slicer.append("KISSlicer")
        }
        if(slicerSelected){
            slicer.append("Slic3r")
        }
        
        if(self.filePath == nil){
            self.view.makeToast("No stl file selected")
        }
        else if(layerHeightEditText.text == "" || infillPerchentageEditText.text == "" || PrintSpeedEditText.text == "" || USHourEditText.text == "" || USDGramEditText.text == ""){
            self.view.makeToast("One of the fields is empty")
        }
        else if(!(layerHeightEditText.text?.isFloat)! || !(infillPerchentageEditText.text?.isFloat)! || !(PrintSpeedEditText.text?.isFloat)! || !(USHourEditText.text?.isFloat)! || !(USDGramEditText.text?.isFloat)! ){
            self.view.makeToast("One of the fields is not number")
        }
        else if(slicer.count==0){
            self.view.makeToast("No slicer selected")
        }
        else{
            DispatchQueue.main.async {
                self.loadingImage.image = UIImage.gif(name: "gear2")
                self.loadingImage.isHidden = false
                self.hideForm()
            }
            
            do{
                let request = try self.createRequest(layerHeight: layerHeightEditText.text!, infillPercentage: infillPerchentageEditText.text!, printSpeed: PrintSpeedEditText.text!, pricePerHour: USHourEditText.text!, pricePerGram: USDGramEditText.text!, material: PlaAbsRadio.titleForSegment(at: PlaAbsRadio.selectedSegmentIndex)!, slicer: slicer)
                
                let task = URLSession.shared.dataTask(with: request){data, response, error in
                    guard error == nil && data != nil else{
                        print("error")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("responseString = \(responseString)")
                    
                    var doc:Document?
                    do {
                        doc = try SwiftSoup.parse(responseString!)
                    } catch Exception.Error( _, let message) {
                        print(message)
                    } catch {
                        print("error")
                    }
                    var elements: Elements?
                    do{
                        elements = try doc?.getElementsByClass("slicer")
                    }
                    catch {
                        print("error")
                    }
                    
                    self.resultElements = elements!
                    
                    
                    DispatchQueue.main.async {
                        self.loadingImage.isHidden = true
                        self.showForm()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "CostResults") as! CostResultsViewController
                        vc.resultElements = self.resultElements
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    
                }
                task.resume()
                
            }
            catch{
                print(error)
                DispatchQueue.main.async {
                    self.loadingImage.isHidden = true
                    self.showForm()
                }
            }
        }
        
    }
    
    
    func createRequest(layerHeight: String, infillPercentage: String, printSpeed: String, pricePerHour: String, pricePerGram: String, material: String, slicer: [String]) throws -> URLRequest {
        
        var parameters = [
            "layerHeight" : layerHeight,
            "infillPercentage" : infillPercentage,
            "printSpeed" : printSpeed,
            "pricePerHour" : pricePerHour,
            "pricePerGram" : pricePerGram,
            "material" : material,
            ]
        
        var i = 0
        for slice in slicer{
            parameters.updateValue(slice, forKey: "slicer["+String(describing: i)+"]")
            i = i+1
        }
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: "http://3dpartprice.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBody(with: parameters, path: String(describing: self.filePath!), boundary: boundary)
        
        return request
    }
    
    
    private func createBody(with parameters: [String: String]?, path: String, boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        let filename = "upload.stl"
        let data = try Data(contentsOf: URL(string: path)!)
        let mimetype = mimeType(for: path)
        
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"stlFile\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
        body.append(data)
        body.append(Data("\r\n".utf8))
        
        
        body.append(Data("--\(boundary)--\r\n".utf8))
        return body
    }
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    private func showForm(){
        layerHeightLabel.isHidden = false
        infillPercentageLabel.isHidden = false
        printSpeedLabel.isHidden = false
        pricePerHourLabel.isHidden = false
        pricePerGramLabel.isHidden = false
        infillPercantageText.isHidden = false
        printSpeedText1.isHidden = false
        printSpeedText2.isHidden = false
        layerHeightText.isHidden = false
        USDHourText.isHidden = false
        USDGramText.isHidden = false
        materialLabel.isHidden = false
        slicerLabel.isHidden = false
        
        layerHeightEditText.isHidden = false
        infillPerchentageEditText.isHidden = false
        PrintSpeedEditText.isHidden = false
        USHourEditText.isHidden = false
        USDGramEditText.isHidden = false
        PlaAbsRadio.isHidden = false
        
        CuraSlicerButton.isHidden = false
        KissSlicerButton.isHidden = false
        Slic3rSlicerButton.isHidden = false
        
        calculateCostButtonOutlet.isHidden = false
    }
    
    private func hideForm(){
        layerHeightLabel.isHidden = true
        infillPercentageLabel.isHidden = true
        printSpeedLabel.isHidden = true
        pricePerHourLabel.isHidden = true
        pricePerGramLabel.isHidden = true
        infillPercantageText.isHidden = true
        printSpeedText1.isHidden = true
        printSpeedText2.isHidden = true
        layerHeightText.isHidden = true
        USDHourText.isHidden = true
        USDGramText.isHidden = true
        materialLabel.isHidden = true
        slicerLabel.isHidden = true
        
        layerHeightEditText.isHidden = true
        infillPerchentageEditText.isHidden = true
        PrintSpeedEditText.isHidden = true
        USHourEditText.isHidden = true
        USDGramEditText.isHidden = true
        PlaAbsRadio.isHidden = true
        
        CuraSlicerButton.isHidden = true
        KissSlicerButton.isHidden = true
        Slic3rSlicerButton.isHidden = true
        
        calculateCostButtonOutlet.isHidden = true
        
    }
    
    
    
}
