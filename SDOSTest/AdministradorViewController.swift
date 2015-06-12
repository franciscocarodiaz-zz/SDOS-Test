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
    
    var taskList = ["0","1","2","3","4","5","6"]
    
    @IBOutlet weak var descriptionTask: UITextView!
    
    @IBOutlet weak var durationTask: UIStepper!
    @IBOutlet weak var numberOfHoursOfTask: UILabel!
    
    @IBOutlet weak var typeTask: UIPickerView!
    var typeTaskSelected :NSString! = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            //self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameUser = prefs.objectForKey("NAME") as? String
        
        self.title = "Administrador: \(self.nameUser)"
        
        let logOutButton = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logOut:")
        self.navigationItem.leftBarButtonItem = logOutButton
        
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
        vc.managedObjectContext = self.managedObjectContext
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
                alertView.message = "PLEASE FILL OUT FORM COMPLETELY"
        }
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    @IBAction func insertNewTask(sender: UIBarButtonItem) {
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! NSManagedObject
        
        // 1. Check desc, time, type is not empty
        let descriptionTask:NSString = self.descriptionTask.text
        let numberOfHoursOfTask:NSString = self.numberOfHoursOfTask.text!
        let typeTask:NSString = self.typeTaskSelected
        
        if (descriptionTask.isEqualToString("")) {
            self.showError(0)
        }else if (numberOfHoursOfTask.isEqualToString("0")) {
            self.showError(1)
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // 2. Buscar técnico que tenga type en sus skills
                
                
                // 3. De la lista de usuarios con ese type, escogemos al que tenga menos horas ese día
                
                newManagedObject.setValue(NSDate(), forKey: "datetask")
                
                // Save the context.
                var error: NSError? = nil
                if !context.save(&error) {
                    abort()
                }
            })
        
        }
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "datetask", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let name = self.nameUser {
            let predicate = NSPredicate(format: "name == %@", self.nameUser!)
            fetchRequest.predicate = predicate
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "SDOSTest")
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            abort()
        }
        
        return _fetchedResultsController!
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
        self.typeTaskSelected = taskList[row]
        return taskList[row]
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}