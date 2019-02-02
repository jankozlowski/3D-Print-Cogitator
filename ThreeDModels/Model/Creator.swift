import Foundation

class Creator: NSObject, Decodable {
    
    var id: Int?
    var name: String?
    var firstName: String?
    var lastName: String?
    var url: String?
    var publicUrl: String?
    var thumbnail: String?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case firstName = "first_name"
        case lastName = "last_name"
        case url = "url"
        case publicUrl = "public_url"
        case thumbnail = "thumbnail"
    }
    
}
