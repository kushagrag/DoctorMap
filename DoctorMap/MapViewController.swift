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

let API_KEY = "D18gu+vKDIls9zuftc/zQx6c5F0="
let CLIENT_ID = "d0f8c219-b504-4ead-9c78-705bcfab2e21"
var doctors:[Doctor] = []
var favDoctorList:[Int]!

class MapViewController: UIViewController, CLLocationManagerDelegate, iCarouselDelegate, iCarouselDataSource, GMSMapViewDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var carouselView: iCarousel!
    override func viewDidLoad() {
        print(AppDelegate.googleMapsApiKey)
        carouselView.type = iCarouselType.Linear
        carouselView.delegate = self
        carouselView.dataSource = self
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        print(mapView.myLocation)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        do{
            let users = try managedContext.executeFetchRequest(fetchRequest)
            let curUser = users[0]
            if curUser.valueForKey("favDoctors") == nil{
                favDoctorList = []
            }
            else{
                favDoctorList = curUser.valueForKey("favDoctors") as! [Int]
            }
        }catch let error as NSError{
            print("Data not fetched \(error), \(error.userInfo)")
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        
        let geocoder = GMSGeocoder()

        print()
        
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

    
    func showDoctors(city: String, near: String){
        
        Alamofire.request(.GET, "https://api.practo.com/search", parameters: ["city":city,"near":near, "sort_by":"distance"], headers:["X-API-KEY":API_KEY, "X-CLIENT-ID":CLIENT_ID]).responseJSON { response in
            
            if let result_json = response.result.value {
                let docs = result_json["doctors"] as? NSArray
                for doc in docs!{
                    let docId = doc.valueForKey("doctor_id") as! Int
                    if doctors.indexOf({$0.docId == docId}) == nil{
                        
                        let name = doc.valueForKey("doctor_name") as! String
                        let speciality = (doc.valueForKey("specialties")![0]["specialty"]) as! String
                        let photoUrl:String!
                        let longitude = doc.valueForKey("longitude")! as! Double
                        let latitude = doc.valueForKey("latitude")! as! Double

                        if doc.valueForKey("photos")!.count != 0{
                            photoUrl = (doc.valueForKey("photos")![0]["url"]) as! String
                        }
                        else {
                            photoUrl = "docImage"
                        }
                        let position = CLLocationCoordinate2DMake(latitude, longitude)
                        let marker = GMSMarker(position: position)
                        marker.appearAnimation = kGMSMarkerAnimationPop
                        marker.title = name
                        marker.userData = docId
                        doctors.append(Doctor(docId: docId, name: name, speciality: speciality, photoUrl: photoUrl, longitude: longitude, latitude: latitude, marker: marker))
                        marker.map = self.mapView
                    }
                }
                let visibleRegion : GMSVisibleRegion = self.mapView.projection.visibleRegion()
                let bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.farRight)
                let northeast = bounds.northEast
                let southwest = bounds.southWest
                
                var temp:[Doctor] = []
                for doc in doctors{
                    let lat = doc.latitude
                    let long = doc.longitude
                    if lat > northeast.latitude || lat < southwest.latitude || long > northeast.longitude || long < southwest.longitude{
                        let marker = doc.marker
                        marker.map = nil
                    }
                    else {
                        temp.append(doc)
                    }
                }
                doctors.removeAll(keepCapacity: true)
                for x in temp{
                    doctors.append(x)
                }
                temp.removeAll()
                dispatch_async(dispatch_get_main_queue(), {self.carouselView.reloadData()})
            }
            
        }

    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        let index = doctors.indexOf({$0.docId == marker.userData as! Int})!
        dispatch_async(dispatch_get_main_queue(),{self.carouselView.scrollToItemAtIndex(index, animated: true)})

        return true
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int
    {
        return doctors.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        var carView:CarouselTableViewCell!
        carView = NSBundle.mainBundle().loadNibNamed("CarouselTableViewCell", owner: self, options: nil)[0] as? CarouselTableViewCell
        carView.name.text = doctors[index].name
        carView.speciality.text = doctors[index].speciality
        carView.docId = doctors[index].docId
        if doctors[index].photoUrl == "docImage"{
            carView.photoView.image = UIImage(named: "docImage")
        }
        else{
            Alamofire.request(.GET, doctors[index].photoUrl).responseJSON{response in
                carView.photoView.image = UIImage(data: response.data!)
            }
        }
        if favDoctorList.indexOf(doctors[index].docId) == nil{
            carView.isFav = false
            carView.favouriteButton.setImage(UIImage(named:"emptyStar"), forState: .Normal)
        }
        else{
            carView.isFav = true
            carView.favouriteButton.setImage(UIImage(named:"filledStar"), forState: .Normal)
        }
        return carView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .Wrap{
            return 1
        }
        if option == .Spacing{
            return value*1.1
        }
        return value
    }
    
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        let docId = doctors[index].docId
        self.performSegueWithIdentifier("doctorSegue",sender: docId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
            let destinationVC = segue.destinationViewController as! DoctorViewController
            let docId = sender as! Int
            destinationVC.docId = docId
    }
    
    
}
