import Foundation

class ModelSizes: NSObject, Decodable {
    
    var type: String?
    var size: String?
    var url: String?
    
    enum CodingKeys : String, CodingKey {
        case type = "type"
        case size = "size"
        case url = "url"
    }
    
}
