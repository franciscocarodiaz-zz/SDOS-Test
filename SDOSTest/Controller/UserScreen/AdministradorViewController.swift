//
//  AdministradorViewController.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 11/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import UIKit
import CoreData

class AdministradorViewController: UIViewController,UITextFieldDelegate{
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var nameUser : String! = nil
    
    var taskList = [TypeTask]()
    
    @IBOutlet weak var descriptionTask: UITextView!
    
    @IBOutlet weak var durationTask: UIStepper!
    @IBOutlet weak var numberOfHoursOfTask: UILabel!
    
    @IBOutlet weak var typeTask: UIPickerView!
    var typeTaskSelected :TypeTask! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameUser = prefs.objectForKey("NAME") as? String
        
        self.title = "Administrador: \(self.nameUser)"
        
        let logOutButton = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logOut:")
        self.navigationItem.leftBarButtonItem = logOutButton
        
        DataManager.getTypeTaskList { (data) -> Void in
            self.taskList = data;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logOut(sender: AnyObject) {
        // 1. Clean data
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        prefs.removePersistentDomainForName(appDomain!)
        
        // 2. Load new screen
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        // 3. Navigate to new screen
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showError(code: Int){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Data error!"
        switch(code){
            case 0:
                alertView.message = "PLEASE FILL OUT DESCRIPTION PARAMETER"
            case 1:
                alertView.message = "PLEASE FILL OUT NUMBER OF HOURS"
            default:
                alertView.message = "TASK NO ASSIGNED"
        }
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    
    
    func showMessage(userName: String){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "assigned to \(userName)"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    @IBAction func insertNewTask(sender: UIBarButtonItem) {
        let context = SDOSCoreDataStack.sharedManager.managedObjectContext
        let entity = "Task"
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context!) as! NSManagedObject
        
        // 1. Check desc, time, type is not empty
        let descriptionTask : String = self.descriptionTask.text as String
        let numberOfHoursOfTask = self.numberOfHoursOfTask.text!
        let typeTask : String = self.typeTaskSelected.valueForKey("ident") as! String
        
        if (descriptionTask == "") {
            self.showError(0)
        }else if (numberOfHoursOfTask == "0") {
            self.showError(1)
        }else{
            let task = Task(description: descriptionTask, duration: numberOfHoursOfTask, typeTaskItem: self.typeTaskSelected)
            
            if task.isValid() {
                showMessage(task.user.name)
            }else{
                showError(2)
            }
            
            
        }
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    @IBAction func updateHoursTask(sender: UIStepper) {
        numberOfHoursOfTask.text = Int(sender.value).description
    }
    
    // pragma MARK: UIPickerViewDataSource Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskList.count
    }
    
    // pragma MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var res = taskList[row].valueForKey("name") as! String
        self.typeTaskSelected = taskList[row]
        return res
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}