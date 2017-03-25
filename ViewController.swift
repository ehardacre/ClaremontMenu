//
//  ViewController.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 1/18/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

import CoreData

class ViewController: UIViewController, UITabBarDelegate , UITableViewDelegate , UITableViewDataSource{
    
    //selected DiningHall and it's corresponding number to be used in the URL
    var selectedDiningHall : String!
    var diningHallNumber : String!
    //meal to be shown
    var selectedMeal : String!
    var selectedItem : String?
    //URL for ASPC API
    var url : String = "http://www.claremontmenu.com/pdo/getFood.php?school="
    //selected food item
    var ratingVC : RatingView?
    var apiDay : String?
    var imageArray = [String]()
    var imgURL = String()
    var DBURL = "http://www.claremontmenu.com/pdo/getFood.php?school="
    var DBIntro = "&name[]="
    var foodOnMenu = false
    
    
    //tab bar for the dining Halls
    @IBOutlet weak var tabbar: UITabBar!
    //tab bar items for the dining Halls
    @IBOutlet weak var rate: UIBarButtonItem!
    @IBOutlet weak var frank: UITabBarItem!
    @IBOutlet weak var frary: UITabBarItem!
    @IBOutlet weak var oldenborg: UITabBarItem!
    @IBOutlet weak var collins: UITabBarItem!
    @IBOutlet weak var scripps: UITabBarItem!
    @IBOutlet weak var pitzer: UITabBarItem!
    @IBOutlet weak var mudd: UITabBarItem!
    //the button with dining hall name
    @IBOutlet weak var DineButton: UIButton!
    //table view to house food data
    @IBOutlet weak var tableView: UITableView!
    //label for the current meal
    @IBOutlet weak var mealLabel: UILabel!
    
    
    //shows dining hall pop up when clicked
    @IBAction func showPopUp(_ sender: Any) {
        //link from pop up on story board and add to main view controller
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        popOverVC.mainViewController = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        //set the Title of thePop up and the corresponding image
        popOverVC.titleLabel.text = DineButton.titleLabel?.text
        switch popOverVC.titleLabel.text!{
        case "FRANK" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "frankImg")
        case "FRARY" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "frary")
        case "COLLINS" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "collinsImg")
        case "OLDENBORG" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "oldenborgImg")
        case "SCRIPPS" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "scrippsImg")
        case "HARVEY MUDD" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "muddImg")
        case "PITZER" :
            popOverVC.diningHallImage.image = #imageLiteral(resourceName: "pitzerImg")
        default : break
        }
        //set the meal picker to the current meal being viewed
        if apiDay == "sat" || apiDay == "sun"{
            popOverVC.pickerData = ["Brunch" , "Dinner"]
            if selectedMeal == "brunch"{
                popOverVC.MealPicker.selectRow(0, inComponent: 0, animated: true)
            }else if selectedMeal == "dinner" {
                popOverVC.MealPicker.selectRow(1, inComponent: 0, animated: true)
            }
        
        }else{
            popOverVC.pickerData = ["Breakfast" , "Lunch" , "Dinner"]
            if selectedMeal == "breakfast"{
                popOverVC.MealPicker.selectRow(0, inComponent: 0, animated: true)
            }else if selectedMeal == "lunch"{
                popOverVC.MealPicker.selectRow(1, inComponent: 0, animated: true)
            }else if selectedMeal == "dinner"{
                popOverVC.MealPicker.selectRow(2, inComponent: 0, animated: true)
            }
    }
    }
    
    //Index to keep track of what dining hall is being viewed on swipe left and swipe right
    var index : Int?
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if index != 0{
            tabbar.selectedItem = tabbar.items![index! - 1]
            convertItem(item: tabbar.selectedItem!)
            
        }
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if index != 6{
            tabbar.selectedItem = tabbar.items![index! + 1]
            convertItem(item: tabbar.selectedItem!)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Setting the initial dining hall
        if selectedDiningHall == nil {
            DineButton.setTitle("FRANK", for: .normal)
            selectedDiningHall = "frank"
            diningHallNumber = "0"
            tabbar.selectedItem = tabbar.items![0]
            index = 0
        }
            switch selectedDiningHall{
            case "frary":
                diningHallNumber = "1"
                DineButton.setTitle("FRARY", for: .normal)
                index = 1
                tabbar.selectedItem = tabbar.items![index!]
                break
            case "frank":
                diningHallNumber = "0"
                DineButton.setTitle("FRANK", for: .normal)
                index = 0
                tabbar.selectedItem = tabbar.items![index!]

                break
            case "collins":
                diningHallNumber = "3"
                DineButton.setTitle("COLLINS", for: .normal)
                index = 3
                tabbar.selectedItem = tabbar.items![index!]

                break
            case "scripps":
                diningHallNumber = "4"
                DineButton.setTitle("SCRIPPS", for: .normal)
                index = 4
                tabbar.selectedItem = tabbar.items![index!]
                break
            case "mudd":
                diningHallNumber = "6"
                DineButton.setTitle("HARVEY MUDD", for: .normal)
                index = 6
                tabbar.selectedItem = tabbar.items![index!]

                break
            case "oldenborg":
                diningHallNumber = "2"
                DineButton.setTitle("OLDENBORG", for: .normal)
                index = 2
                tabbar.selectedItem = tabbar.items![index!]

                break
            case "pitzer":
                diningHallNumber = "5"
                DineButton.setTitle("PITZER", for: .normal)
                index = 5
                tabbar.selectedItem = tabbar.items![index!]

                break
            default:
                diningHallNumber = "0"
                DineButton.setTitle("FRANK", for: .normal)
                index = 0
                tabbar.selectedItem = tabbar.items![index!]

                break
            

        }
        //setting up the day of the week for the API
        let dayAsInt = NSDate().dayOfWeek()!
        switch  dayAsInt{
        case 1:
            apiDay = "sun"
        case 2:
            apiDay = "mon"
        case 3:
            apiDay = "tue"
        case 4:
            apiDay = "wed"
        case 5:
            apiDay = "thu"
        case 6:
            apiDay = "fri"
        case 7:
            apiDay = "sat"
        default:
            apiDay = ""
        }
        //getting the current hour in order to set the meal initially
        let date = Date()
        let hour = Calendar.current.component(.hour, from: date)
        if selectedMeal == nil{
            if apiDay != "sat" || apiDay != "sun"{
                if hour < 10{
                    selectedMeal = "breakfast"
                }else if hour < 14{
                    selectedMeal = "lunch"
                }else{
                    selectedMeal = "dinner"
                }
            }else{
                if hour < 13{
                    selectedMeal = "brunch"
                }else{
                    selectedMeal = "dinner"
                }
            }
        }
        //setting the meal label tex equal to the selected meal
        mealLabel.text = selectedMeal
        
        requestData()
        print(fullMenu.menuItems)
        //getFoodImages()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //change tab bar when Item is Selected
        convertItem(item: item)
    }
    
    //TABLE VIEW INHERIT FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.foodOnMenu{
            return fullMenu.reorderedMenu.count
        }else{
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(fullMenu.reorderedMenu[indexPath.row])
        self.selectedItem = fullMenu.reorderedMenu[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //custom cells for the main tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! CustomCell
            //setting the foodName of the cell
            cell.foodName.text = fullMenu.reorderedMenu[indexPath.row]
            //setting the image that is in the cell
            if fullMenu.itemImages[indexPath.row] != "nil" {
                cell.foodImage?.sd_setImage(with: URL(string: fullMenu.itemImages[indexPath.row]))
            }else{
                cell.foodImage.image = #imageLiteral(resourceName: "defaultFood")
            }
            cell.foodImage.layer.cornerRadius = cell.foodImage.frame.height/2
            cell.foodImage.clipsToBounds = true
            //setting the cosmos view to the correct rating
            let rating = round(fullMenu.itemRatings[indexPath.row] * 10) / 10
            cell.foodRating.rating = Double(rating)
            cell.ratingLabel.text = String(rating)
            
            return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //maintaining variables by passing them to the rating view
        if segue.identifier == "toRateView" {
            let destination : RatingView = segue.destination as! RatingView
            destination.foodName = fullMenu.reorderedMenu[(tableView.indexPathForSelectedRow?.row)!]
            destination.foodID = fullMenu.foodIDs[(tableView.indexPathForSelectedRow?.row)!]
            destination.homeVC = self
            destination.diningHall = selectedDiningHall
            destination.imageURL = URL(string: fullMenu.itemImages[(tableView.indexPathForSelectedRow?.row)!])
            destination.meal = selectedMeal
        }
    }
    
    //converting all the titles when a tab bar item is selected
    func convertItem(item: UITabBarItem){
        switch item{
        case frary:
            selectedDiningHall = "frary"
            diningHallNumber = "1"
            DineButton.setTitle("FRARY", for: .normal)
            index = 1
            requestData()
            break
        case frank:
            selectedDiningHall = "frank"
            diningHallNumber = "0"
            DineButton.setTitle("FRANK", for: .normal)
            index = 0
            requestData()
            break
        case collins:
            selectedDiningHall = "cmc"
            diningHallNumber = "3"
            DineButton.setTitle("COLLINS", for: .normal)
            index = 3
            requestData()
            //getFoodImages()
            break
        case scripps:
            selectedDiningHall = "scripps"
            diningHallNumber = "4"
            DineButton.setTitle("SCRIPPS", for: .normal)
            index = 4
            requestData()
            break
        case mudd:
            selectedDiningHall = "mudd"
            diningHallNumber = "6"
            DineButton.setTitle("HARVEY MUDD", for: .normal)
            index = 6
            requestData()
            //getFoodImages()
            break
        case oldenborg:
            selectedDiningHall = "oldenborg"
            diningHallNumber = "2"
            DineButton.setTitle("OLDENBORG", for: .normal)
            index = 2
            requestData()
            //getFoodImages()
            break
        case pitzer:
            selectedDiningHall = "pitzer"
            diningHallNumber = "5"
            DineButton.setTitle("PITZER", for: .normal)
            index = 5
            requestData()
            //getFoodImages()
            break
        default:
            selectedDiningHall = ""
        }

    }
    
    //Alamomfire request that gets the data from ASPC API
    
    func requestData(){
        let url = "https://aspc.pomona.edu/api/menu/dining_hall/"+selectedDiningHall
        let urL = "/day/"+apiDay!
        let uRL = "/meal/" + selectedMeal
        let uRl = "?auth_token=a35dd8b9788980673f6f0df9b7d2464a34c33e67"
        let APIURL = url + urL + uRL + uRl
        fullMenu.menuItems.removeAll()
        
        Alamofire.request(APIURL , method: .get).validate().responseJSON { (responseData) -> Void in
            if ((responseData.result.value != nil)){
                let json = JSON(responseData.result.value!)
                let foodItems = json[0]["food_items"]
                if (foodItems.count != 0){
                    self.foodOnMenu = true
                    fullMenu.menuItems = foodItems.arrayObject as! [String]
                }else{
                    self.foodOnMenu = false
                }
            }else{
                print("nil")
            }
            if self.foodOnMenu {
                self.getFoodInformation()
            }else{
                self.tableView.reloadData()
            }
        }

    }
    
    //Alamofire request that formats the food Items to order of the Database 
    //grabbing images and ratings as well
    
    func getFoodInformation(){
        //clear the arrays so they don't continue to build
        fullMenu.itemImages.removeAll()
        fullMenu.reorderedMenu.removeAll()
        fullMenu.itemRatings.removeAll()
        fullMenu.foodIDs.removeAll()
        //Database URL
        DBURL = "http://www.claremontmenu.com/pdo/getFood.php?school="
        //formatting the URL to pull the right food Items
        if fullMenu.menuItems.count != 0 {
            DBURL.append(diningHallNumber)
            for i in 0...fullMenu.menuItems.count-1{
                DBURL.append(DBIntro)
                let formattedItem = fullMenu.menuItems[i].replacingOccurrences(of: " ", with: "+")
                DBURL.append(formattedItem)
            }
            //requesting
            Alamofire.request(DBURL , method: .get).validate().responseJSON { (responseData) -> Void in
                if ((responseData.result.value != nil)){
                    let json = JSON(responseData.result.value!)
                    for i in 0...fullMenu.menuItems.count - 1{
                        var rateString = json[i]["rating"].string
                        var foodIDString = json[i]["id"].string
                        if rateString == nil{
                            rateString = "0"
                        }
                        if foodIDString == nil {
                            foodIDString = "0"
                        }
                        let rateInt = Float(rateString!)
                        let foodIDInt = Int(foodIDString!)
                        fullMenu.reorderedMenu.append(json[i]["name"].stringValue)
                        let imageString = json[i]["image"].string
                        if imageString != nil {
                            //let imageURL = URL(string: imageString!)
                            fullMenu.itemImages.append(imageString!)
                        }else{
                            fullMenu.itemImages.append("nil")
                        }
                        fullMenu.itemRatings.append(rateInt!)
                        fullMenu.foodIDs.append(foodIDInt!)
                    }
                }else{
                    print("Food info nil")
                }

                //removing instances of blank food Items that have not been 
                //added to the Database yet
                var i = 0
                while i < fullMenu.reorderedMenu.count{
                    if fullMenu.reorderedMenu[i] == "" || fullMenu.reorderedMenu[i] == " "{
                        fullMenu.reorderedMenu.remove(at: i)
                        fullMenu.itemImages.remove(at: i)
                        fullMenu.foodIDs.remove(at: i)
                        fullMenu.itemRatings.remove(at: i)
                        i -= 1
                    }
                    i += 1
                }
                //re,oad the tableview
                self.tableView.reloadData()
            }

        }
    }
    
    //struct to keep track of the qualities of menuItems
    struct fullMenu{
        static var menuItems = [String]()
        static var reorderedMenu = [String]()
        static var itemImages = [String]()
        static var itemRatings = [Float]()
        static var foodIDs = [Int]()
    }
}

//extension for getting the day of the week
extension NSDate {
    func dayOfWeek() -> Int? {
        guard
            let cal: NSCalendar = Calendar.current as NSCalendar?,
            let comp: NSDateComponents = cal.components(.weekday, from: self as Date) as NSDateComponents? else { return nil }
        return comp.weekday
    }
}

