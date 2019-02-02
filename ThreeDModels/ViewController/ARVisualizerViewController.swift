
import UIKit
import ModelIO
import SceneKit
import SceneKit.ModelIO
import AVFoundation
import FileBrowser


class ARVisualizerViewController: UIViewController, UITextFieldDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    @IBAction func upload(_ sender: Any) {
        
        var customPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let url = URL(string: customPath[0])
        
        let fileBrowser = FileBrowser(initialPath: url)
        present(fileBrowser, animated: true, completion: nil)
        
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            
            
            let asset = MDLAsset(url:file.filePath)
            guard let object = asset.object(at: 0) as? MDLMesh else {
                fatalError("Failed to get mesh from asset.")
            }
            
            self.scene = SCNScene()
            self.node = SCNNode(mdlObject: object)
            self.scene!.rootNode.addChildNode(self.node!)
            self.sceneView.scene = self.scene
            
            self.setSizeBoxes()
            
            print(file.filePath)
        }
        
    }
    @IBAction func dots(_ sender: Any) {
        
        if(invisible){
            invisible = false
            
            plusOutlet.isHidden = true
            minusOutlet.isHidden = true
            upOutlet.isHidden = true
            downOutlet.isHidden = true
            leftOutlet.isHidden = true
            rightOutlet.isHidden = true
            xsize.isHidden = true
            ysize.isHidden = true
            zsize.isHidden = true
            xscale.isHidden = true
            yscale.isHidden = true
            zscale.isHidden = true
            size.isHidden = true
            scale.isHidden = true
            x.isHidden = true
            y.isHidden = true
            z.isHidden = true
            x2.isHidden = true
            y2.isHidden = true
            z2.isHidden = true
            
        }
        else{
            invisible = true
            
            plusOutlet.isHidden = false
            minusOutlet.isHidden = false
            upOutlet.isHidden = false
            downOutlet.isHidden = false
            leftOutlet.isHidden = false
            rightOutlet.isHidden = false
            xsize.isHidden = false
            ysize.isHidden = false
            zsize.isHidden = false
            xscale.isHidden = false
            yscale.isHidden = false
            zscale.isHidden = false
            size.isHidden = false
            scale.isHidden = false
            x.isHidden = false
            y.isHidden = false
            z.isHidden = false
            x2.isHidden = false
            y2.isHidden = false
            z2.isHidden = false
        }
        
    }
    @IBAction func plus(_ sender: Any) {
        sceneView.pointOfView?.camera?.fieldOfView = (sceneView.pointOfView?.camera?.fieldOfView)!-2
        
    }
    @IBAction func minus(_ sender: Any) {
        sceneView.pointOfView?.camera?.fieldOfView = (sceneView.pointOfView?.camera?.fieldOfView)!+2
    }
    @IBAction func left(_ sender: Any) {
        let action = SCNAction.rotateBy(x: 0, y: 0.2, z: 0, duration: 0.5)
        self.scene!.rootNode.runAction(action)
    }
    @IBAction func up(_ sender: Any) {
        let action = SCNAction.rotateBy(x: 0.2, y: 0, z: 0, duration: 0.5)
        self.scene!.rootNode.runAction(action)
    }
    @IBAction func right(_ sender: Any) {
        let action = SCNAction.rotateBy(x: 0, y: -0.2, z: 0, duration: 0.5)
        self.scene!.rootNode.runAction(action)
    }
    @IBAction func down(_ sender: Any) {
        let action = SCNAction.rotateBy(x: -0.2, y: 0, z: 0, duration: 0.5)
        self.scene!.rootNode.runAction(action)
    }
    
    
    
    @IBOutlet weak var dotsOutlet: UIButton!
    @IBOutlet weak var plusOutlet: UIButton!
    @IBOutlet weak var minusOutlet: UIButton!
    @IBOutlet weak var upOutlet: UIButton!
    @IBOutlet weak var downOutlet: UIButton!
    @IBOutlet weak var leftOutlet: UIButton!
    @IBOutlet weak var rightOutlet: UIButton!
    
    @IBOutlet weak var xsize: UITextField!
    @IBOutlet weak var ysize: UITextField!
    @IBOutlet weak var zsize: UITextField!
    
    @IBOutlet weak var xscale: UITextField!
    @IBOutlet weak var yscale: UITextField!
    @IBOutlet weak var zscale: UITextField!
    
    @IBOutlet weak var x: UILabel!
    @IBOutlet weak var y: UILabel!
    @IBOutlet weak var z: UILabel!
    @IBOutlet weak var x2: UILabel!
    @IBOutlet weak var y2: UILabel!
    @IBOutlet weak var z2: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var scale: UILabel!
    
    @IBOutlet weak var sceneView: SCNView!
    
    var node:SCNNode?
    var scene:SCNScene?
    var invisible = true
    var cmnode:SCNNode?
    var sizexStart = 0.0 as Float
    var sizeyStart = 0.0 as Float
    var sizezStart = 0.0 as Float
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xsize!.addTarget(self, action: #selector(FileVisualizerViewController.textViewDidChange(_:)),
                         for: UIControl.Event.editingChanged)
        ysize!.addTarget(self, action: #selector(FileVisualizerViewController.textViewDidChange(_:)),
                         for: UIControl.Event.editingChanged)
        zsize!.addTarget(self, action: #selector(FileVisualizerViewController.textViewDidChange(_:)),
                         for: UIControl.Event.editingChanged)
        xscale!.addTarget(self, action: #selector(FileVisualizerViewController.textViewDidChange(_:)),
                          for: UIControl.Event.editingChanged)
        yscale!.addTarget(self, action: #selector(FileVisualizerViewController.textViewDidChange(_:)),
                          for: UIControl.Event.editingChanged)
        zscale!.addTarget(self, action: #selector(FileVisualizerViewController.textViewDidChange(_:)),
                          for: UIControl.Event.editingChanged)
        
        scene = SCNScene()
        self.node = SCNNode()
        scene!.rootNode.addChildNode(self.node!)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        setupRunningCaptureSession()
        
        makeEditTextLeftMargin(textField: xsize)
        makeEditTextLeftMargin(textField: ysize)
        makeEditTextLeftMargin(textField: zsize)
        makeEditTextLeftMargin(textField: xscale)
        makeEditTextLeftMargin(textField: yscale)
        makeEditTextLeftMargin(textField: zscale)
    }
    
    
    func calculateSize(min: Float, max:Float) -> Float{
        return max-min
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        
        if(textView.tag==1){
            calculateSize(sizeText: xsize, sizeStartValue: self.sizexStart, xyzScale: &node!.scale.x, scaleText: xscale)
        }
        else if(textView.tag==2){
            calculateSize(sizeText: ysize, sizeStartValue: self.sizeyStart, xyzScale: &node!.scale.y, scaleText: yscale)
        }
        else if(textView.tag==3){
            calculateSize(sizeText: zsize, sizeStartValue: self.sizezStart, xyzScale: &node!.scale.z, scaleText: zscale)
        }
        else if(textView.tag==4){
            CalculateScale(scaleText: xscale, sizeStartValue: self.sizexStart, xyzScale: &node!.scale.x, sizeText: xsize)
        }
        else if(textView.tag==5){
            CalculateScale(scaleText: yscale, sizeStartValue: self.sizeyStart, xyzScale: &node!.scale.y, sizeText: ysize)
        }
        else if(textView.tag==6){
            CalculateScale(scaleText: zscale, sizeStartValue: self.sizezStart, xyzScale: &node!.scale.z, sizeText: zsize)
        }
        
        
    }
    
    func calculateSize(sizeText : UITextField, sizeStartValue: Float, xyzScale: inout Float, scaleText : UITextField){
        let stringValueX = sizeText.text!
        if(stringValueX != ""){
            let newScaleX = Float(stringValueX)! / sizeStartValue
            xyzScale = newScaleX
            scaleText.text = String(describing: (newScaleX * 100)) + "%"
        }
    }
    
    func CalculateScale(scaleText : UITextField, sizeStartValue: Float, xyzScale: inout Float, sizeText : UITextField){
        
        let xScaleString = scaleText.text!.replacingOccurrences(of: "%", with: "")
        let newScale = Float(xScaleString)
        
        xyzScale = newScale! / 100.0
        scaleText.text = String(describing: newScale!) + "%"
        
        sizeText.text = String(describing: ( sizeStartValue * newScale! / 100.0))
        
    }
    
    func setSizeBoxes(){
        self.xscale.text = String(describing: (self.node!.scale.x * 100)) + "%"
        self.yscale.text = String(describing: (self.node!.scale.y * 100)) + "%"
        self.zscale.text = String(describing: (self.node!.scale.z * 100)) + "%"
        
        self.xsize.text = String(describing: (calculateSize(min: node!.boundingBox.min.x,max: self.node!.boundingBox.max.x)))
        self.ysize.text = String(describing: (calculateSize(min: self.node!.boundingBox.min.y,max: node!.boundingBox.max.y)))
        self.zsize.text = String(describing: (calculateSize(min: self.node!.boundingBox.min.z,max: node!.boundingBox.max.z)))
        
        self.sizexStart = self.calculateSize(min: self.node!.boundingBox.min.x,max: self.node!.boundingBox.max.x)
        self.sizeyStart = self.calculateSize(min: self.node!.boundingBox.min.y,max: self.node!.boundingBox.max.y)
        self.sizezStart = self.calculateSize(min: self.node!.boundingBox.min.z,max: self.node!.boundingBox.max.z)
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }
        }
    }
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        }
        catch{
            print(error)
        }
    }
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func setupRunningCaptureSession(){
        captureSession.startRunning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func makeEditTextLeftMargin(textField: UITextField){
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
    }
}
