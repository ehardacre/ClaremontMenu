//
//  PopUpViewController.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 1/20/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource{
    @IBOutlet weak var diningHallImage: UIImageView!
    @IBAction func closePopUp(_ sender: Any) {
        removeAnimate()
    }
    
    var pickerData = ["Breakfast" , "Lunch" , "Dinner"]
    @IBOutlet weak var MealPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var mainViewController : ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        //setting alpha component behind pop up
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        //formatting
        diningHallImage.layer.borderColor = UIColor.white.cgColor
        diningHallImage.layer.cornerRadius = 3
        
        
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate(){
        //animation to show the pop up
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        //animation when removing pop up
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
            
        })
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    //picker view for meal selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[0] == "Brunch"{
            if row == 0 {
                mainViewController!.selectedMeal = "brunch"
                mainViewController!.mealLabel.text = "Brunch"
                mainViewController!.requestData()
            }else if row == 1 {
                mainViewController!.selectedMeal = "dinner"
                mainViewController!.mealLabel.text = "Dinner"
                mainViewController!.requestData()
            }
        }else{
            if row == 0 {
                mainViewController!.selectedMeal = "breakfast"
                mainViewController!.mealLabel.text = "Breakfast"
                mainViewController!.requestData()
            }else if row == 1 {
                mainViewController!.selectedMeal = "lunch"
                mainViewController!.mealLabel.text = "Lunch"
                mainViewController!.requestData()
            }else if row == 2 {
                mainViewController!.selectedMeal = "dinner"
                mainViewController!.mealLabel.text = "Dinner"
                mainViewController!.requestData()
            }
        }
    }
    
    //Setting the titles of the picker view Data
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var myTitle = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    

}
