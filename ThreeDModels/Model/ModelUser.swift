import Foundation

class ModelUser: NSObject, Decodable {
    
    var id: Int?
    var name: String?
    var first_name: String?
    var last_name: String?
    var url: String?
    var public_url: String?
    var thumbnail: String?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case first_name = "first_name"
        case last_name = "url"
        case url = "added"
        case public_url = "parent_url"
        case thumbnail = "thumbnail"
        
    }
    
}
