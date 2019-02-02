
import UIKit

class HttpHelper {
    
    
    func httpGet(getUrl: String, completionHandler: @escaping (_ response: String) -> ()){
        var responseString:String?
        let url = URL(string: getUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        //request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            responseString = String(data: data, encoding: .utf8)
            //    print("responseString = \(responseString!)")
            
            completionHandler(responseString!)
            
        }
        task.resume()
        
    }
    
    func readSearchModels(jsonString: String) -> [Model]{
        var model:[Model]?
        
        let decoder = JSONDecoder()
        do {
            model = try decoder.decode([Model].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
            print(model![0].thumbnail)
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        
        if(model == nil){
            model = [Model]()
        }
        
        return model!
    }
    
    func readCategories(jsonString: String) -> [ModelCategory]{
        var categories:[ModelCategory]?
        
        let decoder = JSONDecoder()
        do {
            categories = try decoder.decode([ModelCategory].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        
        return categories!
    }
    
    func readFullSingleModel(jsonString: String) -> FullModel{
        var model:FullModel?
        
        let decoder = JSONDecoder()
        do {
            model = try decoder.decode(FullModel.self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
            //      print(model![0].thumbnail)
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return model!
    }
    
    func readModelImages(jsonString: String) -> [ModelImage]{
        var images:[ModelImage]?
        
        let decoder = JSONDecoder()
        do {
            images = try decoder.decode([ModelImage].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return images!
    }
    
    func readModelMakes(jsonString: String) -> [ModelMake]{
        var models:[ModelMake]?
        
        let decoder = JSONDecoder()
        do {
            models = try decoder.decode([ModelMake].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return models!
    }
    
    func readModelComments(jsonString: String) -> [ModelComment]{
        var comments:[ModelComment]?
        
        let decoder = JSONDecoder()
        do {
            comments = try decoder.decode([ModelComment].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        
        if(comments==nil){
            comments = [ModelComment]()
        }
        
        return comments!
    }
    
    func readModelSizes(jsonString: String) -> [ModelSizes]{
        var sizes:[ModelSizes]?
        
        let decoder = JSONDecoder()
        do {
            sizes = try decoder.decode([ModelSizes].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return sizes!
    }
    
    func readModelMakeSizes(jsonString: String) -> [ModelMakeSizes]{
        var sizes:[ModelMakeSizes]?
        
        let decoder = JSONDecoder()
        do {
            sizes = try decoder.decode([ModelMakeSizes].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return sizes!
    }
    
    func readModelSingleImage(jsonString: String) -> ModelImage{
        var images:ModelImage?
        
        let decoder = JSONDecoder()
        do {
            images = try decoder.decode(ModelImage.self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return images!
    }
    
    func readModelZipPackage(jsonString: String) -> ModelZipPackage{
        var zip:ModelZipPackage?
        
        let decoder = JSONDecoder()
        do {
            zip = try decoder.decode(ModelZipPackage.self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return zip!
    }
    
    func readModelFiles(jsonString: String) -> [ModelFile]{
        var files:[ModelFile]?
        
        let decoder = JSONDecoder()
        do {
            files = try decoder.decode([ModelFile].self, from: jsonString.data(using: .utf8)!)
            print("json downloaded")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            
        }
        return files!
    }
    
    func httpPostAccessToken(postUrl: String) {
        
        let url = URL(string: postUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            
            var code = "";
            
            let codePosition = responseString!.distance(from: responseString!.startIndex, to: (responseString!.range(of: "access_token=")?.upperBound)!)
            
            
            let range = responseString!.index(responseString!.startIndex, offsetBy: codePosition)..<(responseString?.index(of: "&"))!
            
            code = String(responseString![range])
            
            print(code)
            
            
            let defaults = UserDefaults.standard
            defaults.set(code, forKey: "AccessCode")
            
        }
        task.resume()
        
    }
    
    func loadFileAsync(url: URL, name: String, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        print(documentsUrl)
        
        var destinationUrl = documentsUrl
        
        print(destinationUrl)
        
        destinationUrl.appendPathComponent(name)
        
        print(destinationUrl)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}
