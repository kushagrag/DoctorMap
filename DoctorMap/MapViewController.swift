//
//  MapViewController.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 17/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//
import Alamofire
import UIKit
import CoreData
import SwiftyJSON

let API_KEY = "D18gu+vKDIls9zuftc/zQx6c5F0="
let CLIENT_ID = "d0f8c219-b504-4ead-9c78-705bcfab2e21"
var doctors:[Doctor] = []
var favDoctorList:[Int]!

class MapViewController: UIViewController, CLLocationManagerDelegate, iCarouselDelegate, iCarouselDataSource, GMSMapViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var dropDown: UITableView!
    let locationManager = CLLocationManager()
    
    var speciality:String = ""
    var specialities:[String] = []
    var matchingSpecialities:[String] = []
    
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var searchSpeciality: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var carouselView: iCarousel!
    
    //MARK: Delegates
    
    override func viewDidLoad() {
        dropDown.isHidden = true
        dropDown.delegate = self
        dropDown.dataSource = self
        self.dropDown.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        dropDown.layer.cornerRadius = 5
        
        carouselView.type = iCarouselType.linear
        carouselView.delegate = self
        carouselView.dataSource = self
        
        searchSpeciality.enablesReturnKeyAutomatically = false;
        searchSpeciality.delegate = self
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        mapPin.image = UIImage(named: "mapPin")
        
        Alamofire.request("https://api.practo.com/meta/search/cities/1",headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID])
            .validate()
            .responseJSON{
                response in
                switch response.result{
                case .success:
                    let json = JSON(response.result.value!)
                    self.specialities = json["specialties"].arrayValue.map({$0.string!})
                case .failure:
                    print("Cant access specialities")
                }
        }
        super.viewDidLoad()
    }
    
    //MARK: Load Favourites
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        do{
            let users = try managedContext.fetch(fetchRequest)
            let curUser = users[0]
            if curUser.value(forKey: "favDoctors") == nil{
                favDoctorList = []
            }
            else{
                favDoctorList = curUser.value(forKey: "favDoctors") as! [Int]
            }
        }catch let error as NSError{
            print("Data not fetched \(error), \(error.userInfo)")
        }
        carouselView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.mapView(mapView, idleAt: mapView.camera)
    }
    
    //MARK: DropDown Search
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchingSpecialities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = matchingSpecialities[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        speciality = matchingSpecialities[(indexPath as NSIndexPath).row]
        searchSpeciality.text = speciality
        self.searchBarSearchButtonClicked(searchSpeciality)
    }
    
    //MARK: SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       dropDown.isHidden = false
        if searchText == "" {
            dropDown.isHidden = true
        }
        else {
        matchingSpecialities = specialities.filter( {
            $0.range(of: searchText, options: .caseInsensitive) !=  nil
        })
            if matchingSpecialities.count == 0{
                dropDown.isHidden = true
            }
        }

        dropDown.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dropDown.isHidden = true
        searchBar.resignFirstResponder()
        speciality = searchBar.text!
        self.mapView(mapView, idleAt: mapView.camera)
    }

    //MARK: MapDelegates

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    //Scroll to respective carousel card
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        let index = doctors.index(where: {$0.docId == marker.userData as! Int})!
        DispatchQueue.main.async {
            self.carouselView.scrollToItem(at: index, animated: true)
        }
        
        return true
    }
    
    //Reload map when user locks position
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if UtiltyFunction.checkInternetConnection() == false{
            self.alert("To locate Doctors you need active Internet Connection", title: "No Internet Connection") { (action: UIAlertAction!) in
            }
        }
        
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position.target) { response, error in
            if let address = response?.firstResult() {
                var city:String = "Bangalore"
                if address.locality != nil{
                    city = address.locality!
                }
                else if address.subLocality != nil{
                    city = address.subLocality!
                }
                let longitude = position.target.longitude
                let latitude = position.target.latitude
                if city == "Bengaluru"{
                    city = "Bangalore"
                }
                self.showDoctors(city, near: "\(latitude),\(longitude)")
                }
            }
        }
    
    //MARK: Get doctors
    
    func showDoctors(_ city: String, near: String){
        
        //Filterig doctors not of speciality
        if speciality != ""{
            for doctor in doctors{
                doctor.marker.map = nil
            }
            doctors.removeAll()
        }
        
        Alamofire.request("https://api.practo.com/search", parameters: ["city":city,"near":near, "sort_by":"distance", "speciality": speciality], headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID])
            .validate()
            .responseJSON { response in
                
                switch response.result{
                case .success :
                    let json = JSON(response.result.value!)
                    let docs = json["doctors"]
                    for (_,doc) in docs{
                        
                        let docId = doc["doctor_id"].int
                        
                        if doctors.index(where: {$0.docId == docId}) == nil{
                            let name = doc["doctor_name"].string
                            let speciality = doc["specialties"][0]["specialty"].string
                            let photoUrl:String!
                            let longitude = doc["longitude"].double
                            let latitude = doc["latitude"].double
                            
                            if doc["photos"].count != 0{
                                photoUrl = doc["photos"][0]["url"].string
                            }
                            else {
                                photoUrl = "docImage"
                            }
                            
                            let position = CLLocationCoordinate2DMake(latitude!, longitude!)
                            
                            let marker = GMSMarker(position: position)
                            marker.icon = UIImage(named: "doctorPin")
                            marker.appearAnimation = kGMSMarkerAnimationPop
                            marker.title = name
                            marker.userData = docId
                            
                            doctors.append(Doctor(docId: docId!, name: name!, speciality: speciality!, photoUrl: photoUrl, longitude: longitude!, latitude: latitude!, marker: marker))
                            
                            marker.map = self.mapView
                        }
                    }
                    
                    
                    //Removing Markers out of visible region
                    
                    let visibleRegion : GMSVisibleRegion = self.mapView.projection.visibleRegion()
                    let bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.farRight)
                    let northeast = bounds.northEast
                    let southwest = bounds.southWest
                    
                    var temp:[Doctor] = []
                    for doc in doctors{
                        let lat = doc.latitude
                        let long = doc.longitude
                        if lat! > northeast.latitude || lat! < southwest.latitude || long! > northeast.longitude || long! < southwest.longitude{
                            let marker = doc.marker
                            marker?.map = nil
                        }
                        else {
                            temp.append(doc)
                        }
                    }
                    
                    doctors.removeAll(keepingCapacity: true)
                    for x in temp{
                        doctors.append(x)
                    }
                    temp.removeAll()
                    
                    DispatchQueue.main.async {
                        self.carouselView.reloadData()
                    }
                    break
                    
                case .failure : print("Error in getting data")
                    
                }
                    
        }
    }
    
    //MARK: Carousel Delegates
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return doctors.count
    }
    
    //Add doctors to carousel
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        var carView:CarouselTableViewCell!
        carView = Bundle.main.loadNibNamed("CarouselTableViewCell", owner: self, options: nil)?[0] as? CarouselTableViewCell
        carView.name.text = doctors[index].name
        carView.speciality.text = doctors[index].speciality
        carView.docId = doctors[index].docId
        if doctors[index].photoUrl == "docImage"{
            carView.photoView.image = UIImage(named: "docImage")
        }
        else{
            let photoUrl = (doctors[index].photoUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            Alamofire.request(photoUrl!).responseJSON{response in
                carView.photoView.image = UIImage(data: response.data!)
            }
        }
        if favDoctorList.index(of: doctors[index].docId) == nil{
            carView.isFav = false
            carView.favouriteButton.setImage(UIImage(named:"emptyStar"), for: UIControlState())
        }
        else{
            carView.isFav = true
            carView.favouriteButton.setImage(UIImage(named:"filledStar"), for: UIControlState())
        }
        if doctors[index].marker.map == nil{
            doctors[index].marker.map = self.mapView
        }
        return carView
    }
    
    //Set spacing between cells
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .wrap{
            return 1
        }
        if option == .spacing{
            return value*1.1
        }
        return value
    }
    
    //Opening doctor profile on click on carousel
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let docId = doctors[index].docId
        self.performSegue(withIdentifier: "doctorSegue",sender: docId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
            let destinationVC = segue.destination as! DoctorViewController
            let docId = sender as! Int
            destinationVC.docId = docId
    }
    
    
}
