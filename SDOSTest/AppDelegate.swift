//
//  AppDelegate.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 10/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //self.customizeAppearance();
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var storyboard = UIStoryboard(name: SB_WELCOME, bundle: nil)
        var initialViewController = storyboard.instantiateViewControllerWithIdentifier(VC_HOME) as! HomeVC
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func customizeAppearance(){
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        let appearanceViewController = UINavigationBar.appearance();
        appearanceViewController.barTintColor = UIColor.blueColor();
        appearanceViewController.tintColor = UIColor.blueColor();
        appearanceViewController.translucent = true;
        
        var shadow = NSShadow()
        shadow.shadowColor = UIColor.whiteColor()
        shadow.shadowOffset = CGSizeMake(0, 1)
        var color : UIColor = UIColor.blackColor()
        var titleFont : UIFont = UIFont(name: TITLE_FONT, size: 16.0)!

        var attributes = [
            NSForegroundColorAttributeName : color,
            NSShadowAttributeName : shadow,
            NSFontAttributeName : titleFont
        ]
        appearanceViewController.titleTextAttributes = attributes;
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        SDOSCoreDataStack.sharedManager.saveContext()
    }
    

}

