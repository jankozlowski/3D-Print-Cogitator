import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allComents = [ModelComment]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allComents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentViewCell", for: indexPath)
            as! SingleCommentViewCell
        
        cell.comment.text = allComents[indexPath.row].body
        //cell.avatar = allComents[indexPath.row].user?.thumbnail
        cell.date.text = allComents[indexPath.row].added
        cell.name.text = allComents[indexPath.row].user!.name!
        
        cell.avatar.image = UIImage.gif(name: "gear")
        
        let helper = HelperFunctions()
        
        let url = URL(string: (allComents[indexPath.row].user?.thumbnail)!)
        
        helper.getImage(from: url!,completion: {data, response, error in
            
            DispatchQueue.main.async {
                cell.avatar.image = UIImage(data: data!)
            }
            
            
        })
        
        let level = allComents[indexPath.row].level
        
        cell.viewLeadingConstrain.constant = CGFloat(level*20)
        cell.viewTrailingConstrain.constant = CGFloat(level*5)
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage.gif(name: "gear2")
        loadingImage.image = img!
        
        let fullModel = (self.tabBarController!.viewControllers![0] as! SingleModelViewController).fullModel
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessCode")
        let httpHelper:HttpHelper = HttpHelper()
        _ = httpHelper.httpGet(getUrl: "https://api.thingiverse.com/things/"+String(describing: fullModel!.id!)+"/comments?access_token="+accessToken!,completionHandler: {responseString in
            
            //  print(responseString)
            
            let comments = httpHelper.readModelComments(jsonString: responseString)
            
            self.allComents = comments
            
            var noParentComents = [ModelComment]()
            var haveParentComents = [ModelComment]()
            
            //find objects which are children and which are parents
            for comment in self.allComents {
                
                if(comment.parent_id == 0){
                    noParentComents.append(comment)
                }
                else{
                    comment.level = 1
                    haveParentComents.append(comment)
                }
                
            }
            
            //go through all children and find children with parent id same as parent
            while(haveParentComents.count>0){
                var i = 0
                var found = false
                
                for child in haveParentComents{
                    var j = 0
                    
                    for parent in noParentComents{
                        
                        if(child.parent_id==parent.id){
                            
                            j = j+1
                            found = true
                            break
                            
                        }
                        j = j+1
                    }
                    
                    // if same id found add child to parent array one position next to it
                    if(found){
                        
                        noParentComents.insert(child, at: j)
                        break
                    }
                    
                    i = i+1
                }
                
                //delete found child from child array
                if(found){
                    haveParentComents.remove(at: i)
                }
                
            }
            
            //find if thread have replies by reacuring finding if child have parent id other to 0
            for comment in noParentComents{
                var level = 0
                if(comment.parent_id != 0){
                    level = level+1
                    comment.level = level
                    self.searchThreadLevel(noParentComents: noParentComents, originalComment: comment ,searchComment: comment, level: level)
                }
            }

            //while child get parennt id !=0 set level++
            
            print("done")
            
            self.allComents = noParentComents
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                self.loadingImage.isHidden = true
                
            }
            
        })
        
    }
    
    func searchThreadLevel(noParentComents: [ModelComment], originalComment: ModelComment, searchComment: ModelComment, level: Int){
        
        var level = level
        
        for comment2 in noParentComents{
            if(comment2.id == searchComment.parent_id){
                if(comment2.parent_id != 0){
                    level = level+1
                    originalComment.level = level
                    
                    searchThreadLevel(noParentComents: noParentComents, originalComment: originalComment, searchComment: comment2, level: level)
                }
            }
        }
    }
    
}
