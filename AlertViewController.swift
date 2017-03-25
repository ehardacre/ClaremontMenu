//
//  AlertViewController.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 3/19/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    //will be set to the Rating view controller in order to 
    //maintain dining hall and meal
    var mainViewController : RatingView?
    //the rating that the user is submitting
    var rating : Float?
    
    //UI elements
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    //uses the rating view function submitReview in order to submit the rating upon request
    @IBAction func submittingComment(_ sender: Any) {
        mainViewController?.submitReview(textReview: textField.text!, rating: rating!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //formatting the views of the buttons
        cancelButton.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 20
        alertView.layer.cornerRadius = 20
        //setting alpha component of the background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
