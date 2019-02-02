import Foundation

class ModelImage: NSObject, Decodable {
    
    var id: Int?
    var name: String?
    var url: String?
    var sizes: [ModelSizes]?
    
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case url = "url"
        case sizes = "sizes"
    }
    
}
