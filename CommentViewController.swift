//
//  CommentViewController.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 3/18/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommentViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    //UI elements
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //Using rating view in order to maintain Dininghall and meal
    var homeVC: RatingView?
    
    var foodName = String()
    var imageURL : URL?
    var diningHall : String?
    var selectedMeal : String?
    var food_ID = Int()
    var commentArray = [String]()
    //URL for script to retrieve reviews
    var commentsURL = "https://www.claremontmenu.com/pdo/getReviews.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Formatting UI elements
        backButton.layer.cornerRadius = backButton.frame.height / 2
        foodLabel.text = homeVC?.foodName
        foodImage.sd_setImage(with: homeVC?.imageURL)
        foodImage.layer.borderColor = UIColor.blue.cgColor
        foodImage.layer.borderWidth = 1
        foodImage.layer.cornerRadius = foodImage.frame.height / 2
        foodImage.clipsToBounds = true
        
        //converts food_ID to string in order to format URL
        let foodIDString = String(food_ID)
        //Alamofire request for reviews
        Alamofire.request(commentsURL+"?food_id="+foodIDString, method: .get, parameters: ["food_id": food_ID]).responseJSON { (response) in
            if ((response.result.value != nil)){
                //result in JSON format
                let json = JSON(response.result.value!)
                for index in 0...((response.result.value as! [Dictionary<String, AnyObject>]).count){
                    let review = json[index]["review_text"].stringValue
                    if review != ""{
                        //If the review contains a comment add it to the array
                        self.commentArray.append(review)
                    }
                }
            }else{
                print("nil")
            }
            //reverse for newest to oldest
            self.commentArray.reverse()
            //reload the data in the tableView
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //custom TableView cell class for housing comments
        var commentCell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as!  CommentCell
        //formatting so all text fits in cell
        commentCell.commentContainer.text = self.commentArray[indexPath.row]
        commentCell.commentContainer.allowsEditingTextAttributes = false
        
        return commentCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //formatting so all text fits in cell
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the necessary variables back the rating screen from the comment view
        if segue.identifier == "backFromComment" {
            let dest = segue.destination as! RatingView
            dest.foodName = foodLabel.text!
            dest.meal = selectedMeal
            dest.diningHall = diningHall
            dest.imageURL = foodImage.sd_imageURL()
            dest.foodID = food_ID
        }
    }
    
}
