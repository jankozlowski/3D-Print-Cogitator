import Foundation

class ModelCategory: NSObject, Decodable {
    
    var name: String?
    var url: String?
    
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case url = "url"
    }
    
}
