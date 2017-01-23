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
        favTableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    //MARK: Retrieving User Favourites
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        do{
            let users = try managedContext.fetch(fetchRequest)
            let curUser = users[0]
            if curUser.value(forKey: "favDoctors") == nil{
                favList = []
            }
            else{
                favList = curUser.value(forKey: "favDoctors") as! [Int]
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
                doctorList = try managedContext.fetch(fetchRequest)
            }catch let error as NSError{
                print("Data not fetched \(error), \(error.userInfo)")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favTableView.reloadData()
    }
    
    //MARK: TableView Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favList == nil{
            return 0
        }
        
        return favList.count
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavouriteTableViewCell
        let name = doctorList[(indexPath as NSIndexPath).row].value(forKey: "name") as! String
        let speciality = doctorList[(indexPath as NSIndexPath).row].value(forKey: "speciality") as! String
        let photo = doctorList[(indexPath as NSIndexPath).row].value(forKey: "photo") as! Data
        cell.favName.text = name
        cell.favSpeciality.text = speciality
        cell.favImage.image = UIImage(data: photo)
    
        return cell
    
       
    }
    
    //Opening profile of doctor on clivking table card
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "doctorSegue",sender: favList[(indexPath as NSIndexPath).row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        let destinationVC = segue.destination as! DoctorViewController
        let docId = sender as! Int
        destinationVC.docId = docId
    }
    
    //Delete Rows
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        DatabaseHelper.removeFavourite(favList[(indexPath as NSIndexPath).row])
        doctorList.remove(at: (indexPath as NSIndexPath).row)
        favList.remove(at: (indexPath as NSIndexPath).row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
