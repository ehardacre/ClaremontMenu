//
//  RatingView.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 1/22/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit
import Cosmos
import TTGEmojiRate
import Alamofire
import CoreData

class RatingView: UIViewController {
    //View controller to maintain variables
    weak var mainView : ViewController?
    //variables (some from mainview controller)
    var foodName : String = ""
    var prompt = "How did you enjoy the "
    var ratingInt = Float()
    var foodID = Int()
    var homeVC : ViewController?
    var diningHall : String?
    var meal : String?
    var imageURL : URL?
    
    //UI elements
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emojniRate: EmojiRateView!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var bG: UIView!
    @IBOutlet weak var ratingPrompt: UILabel!
    
    
    @IBAction func submit(_ sender: Any) {
        
        //IB Action for submitting the reviews (making pop up for comments)
        let alertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alertVC") as! AlertViewController
        alertVC.mainViewController = self
        print(ratingInt)
        alertVC.rating = ratingInt
        self.addChildViewController(alertVC)
        alertVC.view.frame = self.view.frame
        self.view.addSubview(alertVC.view)
        alertVC.didMove(toParentViewController: self)

    }
    
    func submitReview(textReview: String , rating: Float){
        //function for submitting the reviews using Alamofire library
        let postURL = "http://claremontmenu.com/pdo/addReview.php"
        Alamofire.request(postURL, method: .post, parameters: ["food_id": foodID,"user_id": UIDevice.current.identifierForVendor!.uuidString ,"rating": rating,"review_text": textReview,"created_at": "2017-03-17"]).responseJSON { (reviewID) in
            
            
            print(reviewID.result.value as! Int)
            self.homeVC?.tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        
        //setting labels and formatting UI
        ratingPrompt.text = prompt + foodName + "?"
        ratingPrompt.lineBreakMode = .byWordWrapping
        ratingPrompt.numberOfLines = 0
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        userRating.text = NSString(format: "%.2f", emojniRate.rateValue) as String
        emojniRate.rateValueChangeCallback = {(rateValue: Float) -> Void in
            self.userRating.text = NSString(format: "%.2f", rateValue) as String
            self.ratingInt = rateValue
            print(self.ratingInt)
        }
        backButton.layer.cornerRadius = backButton.frame.height / 2
        commentButton.layer.cornerRadius = commentButton.frame.height / 2
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //preparing for segue to commentview
        if segue.identifier == "toCommentView" {
            let dest = segue.destination as! CommentViewController
            dest.homeVC = self
            dest.diningHall = diningHall
            dest.selectedMeal = meal
            dest.food_ID = foodID
        //preparing for going back to the main view
        }else if segue.identifier == "backFromRate"{
            let dest = segue.destination as! ViewController
            dest.selectedMeal = meal
            print(diningHall)
            dest.selectedDiningHall = diningHall
            
        }
    }
    
}
