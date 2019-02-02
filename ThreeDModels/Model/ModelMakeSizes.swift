import Foundation

class ModelMakeSizes: NSObject, Decodable {
    
    var id: Int?
    var sizes: [ModelSizes]?
    
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case sizes = "sizes"
    }
    
}
