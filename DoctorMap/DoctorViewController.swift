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
        tabBarController?.tabBar.isHidden = true
        //Automatic Height for table view cell
        self.doctorTableView.estimatedRowHeight = 300
        self.doctorTableView.rowHeight = UITableViewAutomaticDimension
        
        if UtiltyFunction.checkInternetConnection() == false{
            self.alert("To see Doctor Profile you need Internet connection", title: "No Internet Connection"){ (action: UIAlertAction!) in
                         self.navigationController?.popViewController(animated: true)
                }
        }
        
        Alamofire.request("https://api.practo.com/doctors/\(docId)", parameters: ["id": docId, "with_relations": "true"], headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID]).responseJSON { response in
            
            switch response.result{
            case .success :
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
                    
                    self.qualification = (doctor["qualifications"][0]["qualification"]["name"].string!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
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
                        self.clinicPhotoUrl = (practice["photos"][0]["url"].string!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
                    
                    DispatchQueue.main.async {
                        self.loadData()
                    }
                    break
                
            case .failure:
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if (indexPath as NSIndexPath).row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.doctorImage.layer.cornerRadius = (cell.doctorImage.frame.width) / 2
            cell.doctorImage.clipsToBounds = true
            if docPhotoUrl == "docImage"{
                cell.doctorImage.image = UIImage(named: "docImage")
            }
            else{
                Alamofire.request(docPhotoUrl).responseJSON{ response in
                    cell.doctorImage.image = UIImage(data: response.data!)
                }
            }
            cell.nameLabel.text = docName
            cell.qualificationLabel.text = qualification
            cell.qualificationLabel.textColor = UIColor.gray
            cell.specialityLabel.text = speciality
            cell.specialityLabel.textColor = UIColor.gray
            cell.experienceLabel.text = "\(experience) years of Experience"
            cell.experienceLabel.textColor = UIColor.gray
            return cell
        }
        else if (indexPath as NSIndexPath).row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.clinicImage.layer.cornerRadius = (cell.clinicImage.frame.width) / 2
            cell.clinicImage.clipsToBounds = true
            if clinicPhotoUrl == "clinicDefault"{
                cell.clinicImage.image = UIImage(named: "clinicDefault")
            }
            else{
                Alamofire.request(clinicPhotoUrl).responseJSON{ response in
                    cell.clinicImage.image = UIImage(data: response.data!)
                }
            }
            
            cell.clinicName.text = clinicName
            cell.locality.text = locality
            
            return cell
        }
        else if (indexPath as NSIndexPath).row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.feeLabel.text = consultationFee
            return cell
        }
        else if (indexPath as NSIndexPath).row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! DoctorTableViewCell
            cell.layer.shadowOffset = CGSize(width: 3, height: 3);
            cell.layer.shadowOpacity = 0.1
            cell.timingLabel.text = timings
            return cell
        }
        else {
            var cell:DoctorTableViewCell!
            if services.count == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "cell8") as! DoctorTableViewCell
                return cell
            }
            else if services.count == 1{
                print("cell5")
                cell = tableView.dequeueReusableCell(withIdentifier: "cell5") as! DoctorTableViewCell
                cell.service1.text = services[0]["service"]["name"].string!
            }
            else if services.count == 2{
                print("cell6")
                cell = tableView.dequeueReusableCell(withIdentifier: "cell6") as! DoctorTableViewCell
                cell.service1.text = services[0]["service"]["name"].string!
                cell.service2.text = services[1]["service"]["name"].string!
            }
            else{
                print("cell7")
                cell = tableView.dequeueReusableCell(withIdentifier: "cell7") as! DoctorTableViewCell
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
