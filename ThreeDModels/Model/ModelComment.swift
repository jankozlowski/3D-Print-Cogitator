import Foundation

class ModelComment: NSObject, Decodable {
    
    var id: Int?
    var target_id: Int?
    var url: String?
    var body: String?
    var added: String?
    var parent_id: Int?
    var parent_url: String?
    var user: ModelUser?
    var level=0
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case target_id = "target_id"
        case body = "body"
        case url = "url"
        case added = "added"
        case parent_id = "parent_id"
        case parent_url = "parent_url"
        case user = "user"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        target_id = try container.decode(Int.self, forKey: .target_id)
        url = try container.decode(String.self, forKey: .url)
        body = try container.decode(String.self, forKey: .body)
        added = try container.decode(String.self, forKey: .added)
        parent_url = try container.decode(String.self, forKey: .parent_url)
        user = try container.decode(ModelUser.self, forKey: .user)
        
        if let value = try? container.decode(Int.self, forKey: .parent_id) {
            parent_id = value
        } else {
            parent_id = 0
        }
    }
    
}
