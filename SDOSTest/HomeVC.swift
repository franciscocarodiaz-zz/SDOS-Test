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
        DataManager.getSDOSDataWithSuccess{ (res) -> Void in
            if(res){
                self.goToLogin();
            }
        }
    }
    
    func goToLogin(){
        self.hideLoader();
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    func goToAdministradorScreen(){
        
        let storyboard = UIStoryboard(name: "Administrador", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AdministradorViewController") as! AdministradorViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.presentViewController(navigationController, animated: true, completion: nil)

    }
    
    func goToTecnicoScreen(){
        
        let storyboard = UIStoryboard(name: "Tecnico", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TecnicoViewController") as! TecnicoViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}