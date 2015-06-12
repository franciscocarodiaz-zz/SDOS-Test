//
//  HomeVC.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 10/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class HomeVC: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet var usernameLabel : UILabel!
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.displayLoader();
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isDataAlreadyLoaded:Int = prefs.integerForKey("ISFIRSTTIME") as Int
        if (isDataAlreadyLoaded == 0) {
            self.loadData();
        } else {
            let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
            if (isLoggedIn == 1) {
                let username:String = prefs.stringForKey("NAME")!
                let usertype:String = prefs.stringForKey("USERTYPE")!
                self.welcomeTitle.text = "Welcome"
                self.usernameLabel.text = username
                UIView.animateWithDuration(2.3, animations: {
                    }, completion: { (finished: Bool) in
                        if usertype == "0"{
                            self.goToAdministradorScreen()
                        }else{
                            self.goToTecnicoScreen()
                        }
                        
                })
            }else{
                self.goToLogin();
            }
        }
    }
    
    func displayLoader(){
        var spinner = VMGearLoadingView(showGearLoadingForView: self.view)
    }
    
    func hideLoader(){
        if let spinner = getGearLoadingForView(self.view) as? VMGearLoadingView{
            spinner.hideGearLoadingForView(spinner)
        }
    }
    
    func loadData(){
        
        DataManager.getUsersSDOSDataFromUrlWithSuccess { (data) -> Void in
            let json = JSON(data: data)
            
            if let total_count = json["total_count"].int {
                println("total_count: \(total_count)")
            }
            
            if let appArray = json["items"].array {
                var users = [Usuario]()
                
                for appDict in appArray {
                    var name: String? = appDict["name"].string
                    var password: String? = appDict["name"].string
                    var phone: String? = appDict["phone"].string
                    var code: String? = appDict["code"].string
                    var usertype: String? = appDict["usertype"].string
                    
                    var skills = [Int]()
                    if let skillArray = appDict["skill"].array {
                        for skillDict in skillArray {
                            var skillItem: Int? = skillDict.int
                            skills.append(skillItem!)
                        }
                    }
                    
                    let user = Usuario(name: name!, password: password!, phone: phone!, code: code!, usertype: usertype!, skill: skills, insertIntoManagedObjectContext: self.managedObjectContext)
                    
                }
                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setInteger(1, forKey: "ISFIRSTTIME")
                prefs.synchronize()
            }
            self.goToLogin();
        }
    }
    
    func goToLogin(){
        self.hideLoader();
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    func goToAdministradorScreen(){
        
        let storyboard = UIStoryboard(name: "Administrador", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AdministradorViewController") as! AdministradorViewController
        vc.managedObjectContext = self.managedObjectContext
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.presentViewController(navigationController, animated: true, completion: nil)

    }
    
    func goToTecnicoScreen(){
        
        let storyboard = UIStoryboard(name: "Tecnico", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TecnicoViewController") as! TecnicoViewController
        vc.managedObjectContext = self.managedObjectContext
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}