
import Foundation

class HelperFunctions {
    
    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func convertDateFormatter(date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFromString : Date
        
        dateFromString = dateFormatter.date(from: date)!
        
        return dateFromString
    }
    
    
}
