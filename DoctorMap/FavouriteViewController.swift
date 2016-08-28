//
//  FavouriteViewController.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 22/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON



class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favTableView: UITableView!
    var favList:[Int]!
    var doctorList:[AnyObject]!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        favTableView.delegate = self
        favTableView.dataSource = self
        let nib = UINib(nibName: "FavouriteTableViewCell", bundle: nil)
        favTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
    }
    
    //MARK: Retrieving User Favourites
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        do{
            let users = try managedContext.executeFetchRequest(fetchRequest)
            let curUser = users[0]
            if curUser.valueForKey("favDoctors") == nil{
                favList = []
            }
            else{
                favList = curUser.valueForKey("favDoctors") as! [Int]
            }
        }catch let error as NSError{
            print("Data not fetched \(error), \(error.userInfo)")
        }
        if favList.count > 0{
            fetchRequest = NSFetchRequest(entityName: "Doctors")
            var predicates:[NSPredicate] = []
            for fav in favList{
                let predicate = NSPredicate(format: "docId == %ld", fav)
                predicates.append(predicate)
            }
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            do{
                doctorList = try managedContext.executeFetchRequest(fetchRequest)
            }catch let error as NSError{
                print("Data not fetched \(error), \(error.userInfo)")
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        favTableView.reloadData()
    }
    
    //MARK: TableView Delegates

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favList == nil{
            return 0
        }
        
        return favList.count
    }

    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FavouriteTableViewCell
        let name = doctorList[indexPath.row].valueForKey("name") as! String
        let speciality = doctorList[indexPath.row].valueForKey("speciality") as! String
        let photo = doctorList[indexPath.row].valueForKey("photo") as! NSData
        cell.favName.text = name
        cell.favSpeciality.text = speciality
        cell.favImage.image = UIImage(data: photo)
    
        return cell
    
       
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("doctorSegue",sender: favList[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let destinationVC = segue.destinationViewController as! DoctorViewController
        let docId = sender as! Int
        destinationVC.docId = docId
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        DatabaseHelper.removeFavourite(favList[indexPath.row])
        doctorList.removeAtIndex(indexPath.row)
        favList.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
