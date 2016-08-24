//
//  AppDelegate.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 17/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

var currentUser:GIDGoogleUser!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    static let googleMapsApiKey = "AIzaSyBOK7YCHAOittlORqY0IoMni_HC1Qh4U5M"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let fileManager = NSFileManager.defaultManager()
        let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        print(documents)
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        GMSServices.provideAPIKey(AppDelegate.googleMapsApiKey)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
//        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
//            print("Already Sign in")
//            GIDSignIn.sharedInstance().signInSilently()
//            
//        }
//        else {
//            print("Not Signed in")
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let signInVC = sb.instantiateViewControllerWithIdentifier("signInView")
//            self.window!.rootViewController = signInVC
//            })
//
//        }
        
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                
                
                withError error: NSError!) {
        
        if (error == nil) {
            currentUser = user
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)

            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                if (results.count == 0){
                    print("User Created")
                    let entity =  NSEntityDescription.entityForName("User",
                                                                    inManagedObjectContext:managedContext)
                    let user = NSManagedObject(entity: entity!,
                                                 insertIntoManagedObjectContext: managedContext)
                    user.setValue(currentUser.userID, forKey: "userId")
                    user.setValue(currentUser.profile.name, forKey: "name")
                    user.setValue(currentUser.profile.email, forKey: "email")
                    var photo:NSData!
                    if currentUser.profile.hasImage == true{
                        Alamofire.request(.GET, currentUser.profile.imageURLWithDimension(128)).responseJSON{response in
                            photo = response.data!
                            user.setValue(photo, forKey: "photo")
                            do {
                                try managedContext.save()
                            } catch let error as NSError  {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                        }
                    
                    }
                    else{
                        photo = UIImagePNGRepresentation(UIImage(named: "profile-default")!)
                        user.setValue(photo, forKey: "photo")
                        do {
                            try managedContext.save()
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                    
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = sb.instantiateViewControllerWithIdentifier("tabBarView") as? UITabBarController {
                window!.rootViewController = tabBarVC
            }
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "practo.DoctorMap" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DoctorMap", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

