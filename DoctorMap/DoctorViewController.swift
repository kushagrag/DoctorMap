//
//  DoctorViewController.swift
//  
//
//  Created by Kushagra Gupta on 23/08/16.
//
//

import UIKit
import Alamofire

class DoctorViewController: UIViewController {

    var docId:Int!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var practiceImage: UIImageView!
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    override func viewDidLoad() {
        tabBarController?.tabBar.hidden = true
        doctorImage.layer.borderWidth = 3.0
        doctorImage.layer.borderColor = UIColor.whiteColor().CGColor
        doctorImage.layer.cornerRadius = 10.0
        doctorImage.clipsToBounds = true
    
        
       
        
        super.viewDidLoad()
        Alamofire.request(.GET, "https://api.practo.com/doctors/\(docId)", parameters: ["id": docId, "with_relations": "true"], headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID]).responseJSON { response in
            print(response.request)
            if let doctor = response.result.value {
                let docName = doctor.valueForKey("name") as! String
                self.nameLabel.text = docName
                let experience = doctor.valueForKey("experience_years") as! Int
                self.experienceLabel.text = "Experience : \(experience)yrs"
                let gender = doctor.valueForKey("gender") as! String
                if gender == "M"{
                    self.genderLabel.text = "Male"
                }
                else{
                    self.genderLabel.text = "Female"
                }
                if doctor.valueForKey("photos")!.count == 0{
                    self.doctorImage.image = UIImage(named: "docImage")
                }
                else{
                   Alamofire.request(.GET, doctor.valueForKey("photos")![0]["photo_url"] as! String).responseJSON{ response in
                        self.doctorImage.image = UIImage(data: response.data!)
                    }
                }
                let practice = doctor.valueForKey("relations")!.valueForKey("practice")![0]
                if practice.valueForKey("photos")!.count == 0{
                    self.practiceImage.image = UIImage(named: "profile-bg")
                }
                else{
                    Alamofire.request(.GET, practice.valueForKey("photos")![0].valueForKey("url") as! String).responseJSON{response in
                        self.practiceImage.image = UIImage(data: response.data!)
                    }
                }
                var address = practice.valueForKey("street_address") as! String
                address = address.stringByReplacingOccurrencesOfString("\r\n", withString: " ")

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 1
                let attrString = NSMutableAttributedString(string: address)
                attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                self.addressLabel.attributedText = attrString
                self.addressLabel.textAlignment = NSTextAlignment.Center
                let consultationFee = doctor.valueForKey("relations")!.valueForKey("consultation_fee")![0]
                self.feeLabel.text = "Consultation Fee : Rs.\(consultationFee)"
                let speciality = doctor.valueForKey("specializations")!.valueForKey("subspecialization")!.valueForKey("subspecialization")
               self.specialityLabel.text = speciality![0] as? String
   
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
