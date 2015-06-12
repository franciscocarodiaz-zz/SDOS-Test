//
//  LoginVC.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 10/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var usernameTitle: UILabel!
    @IBOutlet var passwordTitle: UILabel!
    var users = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapUsername() {
        self.passwordTitle.hidden = true
        self.passwordTitle.alpha = 0
        self.txtUsername.alpha = 1.0
        UIView.animateWithDuration(0.7, animations: {
            }, completion: { (finished: Bool) in
                self.txtPassword.alpha = 0.5
                self.usernameTitle.hidden = false
                self.usernameTitle.alpha = 1.0
        })
    }
    
    @IBAction func tapPassword() {
        self.txtPassword.alpha = 1.0
        self.usernameTitle.hidden = true
        self.usernameTitle.alpha = 0
        UIView.animateWithDuration(0.7, animations: {
            }, completion: { (finished: Bool) in
                self.txtUsername.alpha = 0.5
                self.passwordTitle.hidden = false
                self.passwordTitle.alpha = 1.0
        })
    }
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    func fetchLog(name : NSString) {
        
        let managedContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Usuario")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            users = results
            
            for user in results {
                var name: String? = user.valueForKey("name") as? String
                var phone: String? = user.valueForKey("phone") as? String
                var usertype: String? = user.valueForKey("usertype") as? String
                
                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setObject(name, forKey: "NAME")
                prefs.setObject(phone, forKey: "PHONE")
                prefs.setObject(usertype, forKey: "USERTYPE")
                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                prefs.synchronize()
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        let success:Bool = users.count > 0
        
        NSLog("Success: %ld", success);
        
        if(success)
        {
            NSLog("Login SUCCESS");
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            var error_msg:NSString = "Error"
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = error_msg as String
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        }
    }
    
    func showError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign in Failed!"
        alertView.message = "Please enter Username and Password"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    @IBAction func signinTapped(sender : UIButton) {
        
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            self.showError()
        }else{
            var username:NSString = self.txtUsername.text
            var password:NSString = self.txtPassword.text
            self.fetchLog(username);
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
