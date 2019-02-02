import Foundation

class ModelMake: NSObject, Decodable {
    
    var id: Int?
    var url: String?
    var publicUrl: String?
    var added: String?
    var thumbnail: String?
    var images_url: String?
    var makeSizes: [ModelMakeSizes]?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case url = "url"
        case publicUrl = "public_url"
        case added = "added"
        case thumbnail = "thumbnail"
        case images_url = "images_url"
    }
    
}
