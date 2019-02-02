import Foundation

class ModelZipPackage: NSObject, Decodable {
    
    var url: String?
    var publicUrl: String?
    
    enum CodingKeys : String, CodingKey {
        case url = "url"
        case publicUrl = "public_url"

    }
    
}
