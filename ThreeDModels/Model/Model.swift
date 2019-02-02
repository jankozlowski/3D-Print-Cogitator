import UIKit

class Model: NSObject, Decodable {
    
    var id: Int?
    var name: String?
    var url: String?
    var publicUrl: String?
    var thumbnail: String?
    
    
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case url = "url"
        case publicUrl = "public_url"
        case thumbnail = "thumbnail"
    }
}
