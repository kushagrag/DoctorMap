//
//  DoctorViewController.swift
//  
//
//  Created by Kushagra Gupta on 23/08/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class DoctorViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate,CLLocationManagerDelegate{
    
    var cell:DoctorTableViewCell!
    var docId:Int!
    
    let locationManager = CLLocationManager()
    var map:GMSMapView!
    
    @IBOutlet weak var doctorTableView: UITableView!
    
    var docName:String!
    var experience:Int!
    var qualification:String!
    var docPhotoUrl:String!
    var clinicPhotoUrl:String!
    var consultationFee:String!
    var address:NSMutableAttributedString!
    var speciality:String!
    var locality:String!
    var clinicName:String!
    var timings:String!
    var services:JSON!
    
    
    override func viewDidLoad() {
        tabBarController?.tabBar.hidden = true
        self.doctorTableView.estimatedRowHeight = 300
        self.doctorTableView.rowHeight = UITableViewAutomaticDimension
        if UtiltyFunction.checkInternetConnection() == false{
            self.alert("To see Doctor Profile you need Internet connection", title: "No Internet Connection"){ (action: UIAlertAction!) in
                         self.navigationController?.popViewControllerAnimated(true)
                }
        }
        
        Alamofire.request(.GET, "https://api.practo.com/doctors/\(docId)", parameters: ["id": docId, "with_relations": "true"], headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID]).responseJSON { response in
            
            switch response.result{
            case .Success :
                    let doctor = JSON(response.result.value!)
                    
                    self.docName = doctor["name"].string
                    
                    if doctor["experience_year"] != nil{
                        self.experience = doctor["experience_year"].int
                    }
                    else if doctor["experience_years"] != nil{
                        self.experience = doctor["experience_years"].int
                    }
                    else{
                        self.experience = 0
                    }
                    
                    self.qualification = (doctor["qualifications"][0]["qualification"]["name"].string!).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                    
                    if doctor["photos"].count == 0{
                        self.docPhotoUrl =  "docImage"
                    }
                    else{
                        self.docPhotoUrl = doctor["photos"][0]["photo_url"].string!
                    }
                    
                    let practice = doctor["relations"][0]["practice"]
                    
                    if practice["photos"].count == 0{
                        self.clinicPhotoUrl = "clinicDefault"
                    }
                    else{
                        self.clinicPhotoUrl = (practice["photos"][0]["url"].string!).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                    }
                    
                    if practice["locality"]["name"].string != nil{
                     self.locality = practice["locality"]["name"].string!
                    }
                    else{
                        self.locality = ""
                    }
                    
                    if practice["name"].string != nil{
                        self.clinicName = practice["name"].string!
                    }
                    else{
                        self.clinicName = ""
                    }
                    
                    if practice["timings"] != nil{
                        let time = practice["timings"]["monday"]
                        self.timings = "\(time["session1_start_time"].string!)-\(time["session1_end_time"].string!)"
                        if time["session2_start_time"].string! != ""{
                            self.timings = self.timings + " and \(time["session2_start_time"].string!)-\(time["session2_end_time"].string!)"
                        }
                    }
                    else{
                        self.timings = "Not Available"
                    }
                    
                    self.services = doctor["services"]
                    
                    
                    if doctor["relations"][0]["consultation_fee"].string != nil{
                        self.consultationFee = "Rs.\(doctor["relations"][0]["consultation_fee"].string!)"
                    }
                    else{
                        self.consultationFee = "Not Available"
                    }
                    
                    self.speciality = doctor["specializations"][0]["subspecialization"]["subspecialization"].string
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.loadData()
                        })

                    
                    break
                
            case .Failure:
                print("Cannot show Doctors data")
                
            }
        }
        super.viewDidLoad()
        
    }
    
    func loadData(){
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        doctorTableView.reloadData()
    }
    
    //MARK: TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.doctorImage.layer.cornerRadius = (cell.doctorImage.frame.width) / 2
            cell.doctorImage.clipsToBounds = true
            if docPhotoUrl == "docImage"{
                cell.doctorImage.image = UIImage(named: "docImage")
            }
            else{
                Alamofire.request(.GET, docPhotoUrl).responseJSON{ response in
                    cell.doctorImage.image = UIImage(data: response.data!)
                }
            }
            cell.nameLabel.text = docName
            cell.qualificationLabel.text = qualification
            cell.qualificationLabel.textColor = UIColor.grayColor()
            cell.specialityLabel.text = speciality
            cell.specialityLabel.textColor = UIColor.grayColor()
            cell.experienceLabel.text = "\(experience) years of Experience"
            cell.experienceLabel.textColor = UIColor.grayColor()
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.clinicImage.layer.cornerRadius = (cell.clinicImage.frame.width) / 2
            cell.clinicImage.clipsToBounds = true
            if clinicPhotoUrl == "clinicDefault"{
                cell.clinicImage.image = UIImage(named: "clinicDefault")
            }
            else{
                Alamofire.request(.GET, clinicPhotoUrl).responseJSON{ response in
                    cell.clinicImage.image = UIImage(data: response.data!)
                }
            }
            
            cell.clinicName.text = clinicName
            cell.locality.text = locality
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell3") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.feeLabel.text = consultationFee
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.timingLabel.text = timings
            return cell
        }
        else {
            var cell:DoctorTableViewCell!
            if services.count == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("cell8") as! DoctorTableViewCell
                return cell
            }
            else if services.count == 1{
                print("cell5")
                cell = tableView.dequeueReusableCellWithIdentifier("cell5") as! DoctorTableViewCell
                cell.service1.text = services[0]["service"]["name"].string!
            }
            else if services.count == 2{
                print("cell6")
                cell = tableView.dequeueReusableCellWithIdentifier("cell6") as! DoctorTableViewCell
                cell.service1.text = services[0]["service"]["name"].string!
                cell.service2.text = services[1]["service"]["name"].string!
            }
            else{
                print("cell7")
                cell = tableView.dequeueReusableCellWithIdentifier("cell7") as! DoctorTableViewCell
                cell.service1.text = services[0]["service"]["name"].string!
                cell.service2.text = services[1]["service"]["name"].string!
                cell.service3.text = services[2]["service"]["name"].string!
            }
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            return cell
        }
       
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
