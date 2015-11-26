//
//  AppDelegate.swift
//  WhiteSoxMasterDetail
//
//  Created by Kamal Dandamudi on 10/23/15.
//  Copyright (c) 2015 Kamal Dandamudi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
//        let path = NSBundle.mainBundle().pathForResource("Chicago White Sox", ofType: "plist")
//        let array:[AnyObject] = NSArray(contentsOfFile: path!) as! [AnyObject]
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let masterController = masterNavigationController.viewControllers[0] as! MasterViewController

        
        var downloadFailed = false
        var error: NSError? = nil
        
//        let navigationController = self.window!.rootViewController as! UINavigationController
//        let masterController = navigationController.childViewControllers[0] as! MasterViewController
        
        if let url = NSURL(string: "https://www.prismnet.com/~mcmahon/CS321/WhiteSox.json") {
            
            if let urlData = NSData(contentsOfURL: url) {
                
                if let array: [AnyObject] = NSJSONSerialization.JSONObjectWithData(urlData, options: nil, error: &error) as? [AnyObject] {

        //dictionary of components to display
        for dictionary in array{
            let number = dictionary["Number"]
            let height = dictionary["Height"]
            let position = dictionary["Position"]
            let dob = dictionary["DOB"]
            let first_name = dictionary["First Name"]
            let weight = dictionary["Weight"]
            let last_name = dictionary["Last Name"]
            let bats = dictionary["Bats"]
            let throws = dictionary["Throws"]
            
            
            masterController.objects.append(Player(number: number as! String, firstName: first_name as! String, lastName: last_name as! String, position: position as! String, bats: bats as! String, throws: throws as! String, height: height as! String, weight: weight as! String, DOB: dob as! String))
        }
        
        //sorting of players by last and first name
        masterController.objects.sort({$0.lastName < $1.lastName || ($0.lastName == $1.lastName && $0.firstName < $1.firstName)})
        
                } else {
                    downloadFailed = true
                }
            } else {
                downloadFailed = true
            }
        } else {
            downloadFailed = true
        }
        
        if downloadFailed {
            let alert = UIAlertView(title: "Error", message: "Unable to download course data", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        return true
    }



    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }
    
}


