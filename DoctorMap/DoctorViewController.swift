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
    
    @IBOutlet weak var practiceImage: UIImageView!
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Speciality: UILabel!
    @IBOutlet weak var recommendImage: UIImageView!
    
    @IBOutlet weak var recommendLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, "https://api.practo.com/doctors/\(docId)", parameters: ["id": docId, "with_relations": "true"], headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID]).responseJSON { response in
            
            print(response.request)
            if let result_json = response.result.value {
            print(result_json)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
