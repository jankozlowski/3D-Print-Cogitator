import Foundation

class FullModel: NSObject, Decodable {
    
    var id: Int?
    var name: String?
    var url: String?
    var publicUrl: String?
    var thumbnail: String?
    var autorName: String?
    var autorRepository: String?
    var addDate: String?
    var like_count: Int?
    var collect_count: Int?
    var download_count: Int?
    var view_count:Int?
    var license : String?
    var model_description: String?
    var file_count: Int?
    var files_url: String?
    var images_url: String?
    var creator: Creator?
    
    //var tags
    //var categories
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case url = "url"
        case publicUrl = "public_url"
        case thumbnail = "thumbnail"
        case autorName = "autorName"
        case autorRepository = "autorRepository"
        case addDate = "added"
        case like_count = "like_count"
        case collect_count = "collect_count"
        case download_count = "download_count"
        case view_count = "view_count"
        case license = "license"
        case model_description = "description"
        case file_count = "file_count"
        case files_url = "files_url"
        case images_url = "images_url"
        case creator = "creator"
        
    }
    
}
