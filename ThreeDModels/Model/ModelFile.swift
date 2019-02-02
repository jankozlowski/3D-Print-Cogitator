import Foundation

class ModelFile: NSObject, Decodable {
    
    var id: Int?
    var name: String?
    var size: Int?
    var url: String?
    var public_url: String?
    var download_url: String?
    var date: String?
    var formatted_size: String?
    var download_count: Int?
    var default_image: ModelImage?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case size = "size"
        case url = "url"
        case public_url = "public_url"
        case download_url = "download_url"
        case date = "date"
        case formatted_size = "formatted_size"
        case download_count = "download_count"
        case default_image = "default_image"
        
    }
    
}
