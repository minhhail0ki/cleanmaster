//
//  LocationViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 28/12/2021.
//

import UIKit
import Photos

class LocationViewController: UIViewController {

    @IBAction func Back(){
        self.dismiss(animated: true)
    }
    var assets: [PHAsset] = []
    var coordinator = [Int]()
    
    var listLocation = [[PHAsset]] ()
   
    var listNameA = [String]()
    @IBOutlet weak var locationCollection: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCollection.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        locationCollection.delegate = self
        locationCollection.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator = []
        listLocation = []
        listNameA = []
        getDataImage()
        getLocoal()
       // getLocationPhoto()
        locationCollection.reloadData()
     print("____Hug____")
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        getLocoal()
//        getDataImage()
//    }
    func getLocoal()
    {
        for i in assets where i.location?.coordinate.latitude != nil{
          //  print("\(i.location!.coordinate.latitude), \(i.location!.coordinate.longitude)")
           // print(i.location?.altitude ?? "")
            if coordinator.contains(Int(i.location!.coordinate.latitude)){
                if let index = coordinator.firstIndex(of: Int(i.location!.coordinate.latitude)) {
                    self.listLocation[index].append(i)
                }
               
            }
            else
            {
                self.coordinator.append(Int(i.location!.coordinate.latitude))
                self.listLocation.append([i])
            }
            
        }
        getLocationPhoto(location: listLocation)
       
    }
    
    
    func getLocationPhoto(location:[[PHAsset]])
    {
     
        for i in location{
            let geoCoder = CLGeocoder()
            //let latitude1 = i[0].locationi
            let latitude = i[0].location?.coordinate.latitude
            let longitue = i[0].location?.coordinate.longitude
            let location = CLLocation(latitude:latitude ?? 0 , longitude: longitue ?? 0)
                    geoCoder.reverseGeocodeLocation(location, completionHandler:
                        {
                            placemarks, error -> Void in

                            // Place details
                            guard let placeMark = placemarks?.first else { return }

                          
                            // City
                            if let city = placeMark.subAdministrativeArea {
                                print("city \(city)")
                                
                                if self.listNameA.contains(city){
                                    if let index = self.listNameA.firstIndex(of: city) {
                                        //self.listLocation[index].append(i)
                                    }
                        
                                }else
                                {
                                    self.listNameA.append(city)
                                   // self.listLocation.append([i])
                                }
                                
                                self.locationCollection.reloadData()
                            }
                    })
        }
        print("nó in vào dòng này rồi")
    }
    
    
    func getDataImage(){
        PhotoLibraryManager.shared.authorize(fromViewController: self) {[weak self] (authorized) -> Void in
            guard authorized == true else { return }
            self?.assets.removeAll()
     
            // Lấy ra toàn bộ ảnh trong thư viện ở đây
           self?.assets.append(contentsOf: PhotoLibraryManager.shared.getAllImageAsset())
          
           
        }
    }
}
extension LocationViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listNameA.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
        cell.labelname.text = listNameA[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterByLocationViewController") as! FilterByLocationViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.assets = listLocation[indexPath.row]
        self.present(vc, animated: true)
    }
}

extension LocationViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: collectionView.frame.width / 2 - 10, height: collectionView.frame.width / 2)
        }
        return CGSize(width: collectionView.frame.width / 2 - 10, height: collectionView.frame.width / 2 - 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}
