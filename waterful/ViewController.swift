//
//  ViewController.swift
//  waterful
//
//  Created by suz on 10/9/15.
//  Copyright © 2015 suz. All rights reserved.
//

import UIKit
import CoreData

func createPlant() -> Plant {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    
    let plant_info = NSEntityDescription.insertNewObjectForEntityForName("Plant",
        inManagedObjectContext: managedContext) as! Plant
    plant_info.name = "뚜벅이"
    plant_info.bornDate = NSDate()
    plant_info.type = "포인세티아"
    plant_info.growthRate = 0
    
    do {
        try managedContext.save()
        
    } catch {
        print("Unresolved error")
        abort()
    }
    
    return plant_info
}

func fetchPlant() -> Plant! {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Plant")
    
    let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [Plant]
    
    if (fetchResults!.count == 0){
        return nil
    }
    
    else{
        return fetchResults![0]
    }
}

func getDate(date : NSDate) -> String{
    return (date.description as NSString).substringToIndex(10)
}

func fetchWater() -> String {
    print(String(NSDate))
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "WaterLog")
    
    let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [WaterLog]

    var consumed : Int = 0
    
    let today = getDate(NSDate(timeIntervalSinceNow: NSTimeInterval(NSTimeZone.defaultTimeZone().secondsFromGMT)))
    
    for result in fetchResults! {
        if (getDate(result.loggedTime!) == today){
            print(String(NSDate))
            print("today: " + String(today))
            print(String(result.loggedTime))
            print(getDate(result.loggedTime!))
            consumed = consumed + Int(result.amount!)
        }
    }


    return String(consumed)
}

class ViewController: UIViewController {

    @IBOutlet weak var plant: UIButton!
    
    @IBOutlet weak var plant_name: UILabel!
    
    @IBOutlet weak var plant_type: UILabel!
    
    @IBOutlet weak var plant_dob: UILabel!
    
    @IBOutlet weak var consumed: UILabel!
    
    @IBOutlet weak var goal: UILabel!

    override func viewWillAppear(animated: Bool) {
        // Setting up informatinos about water
        
        consumed.text = fetchWater()
    }
    override func viewDidLoad() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Setting up informations for plant

        var plant_info : Plant! = fetchPlant()
        if (plant_info == nil){
            
            plant_info = createPlant()

            let alertController = UIAlertController(title: "Hello First Time User!", message:
                "You just receieved your plant, 뚜벅이", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "water him", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
        
        plant_name.text = plant_info.name
        plant_dob.text = dateFormatter.stringFromDate(plant_info.bornDate!)
        plant_type.text = plant_info.type
        
        
        
        super.viewDidLoad()
        plant.setBackgroundImage(UIImage(named: "2_sprout.png"), forState: UIControlState.Normal)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

