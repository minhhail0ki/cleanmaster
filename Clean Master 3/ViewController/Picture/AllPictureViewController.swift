//
//  AllPictureViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 29/12/2021.
//

import UIKit
import Photos


class AllPictureViewController: UIViewController {
    var listImageToDelle = [PHAsset]()
    var dem = 0

    var assets: [PHAsset] = []
    var totalFile = 0
    var fileProces = 0
    var workItem: DispatchWorkItem?
    var selectDate = Date()
    
    var allImage = [UIImage]()
    var finalIMAGE = [[UIImage]]()
    var finalAsset = [[PHAsset]]()
    var FilterAsset = [[PHAsset]]()
    var FilterString = [String]()
    
    var allDataImage = [UIImage]()
    var groupImage = [PHAsset]()
    
    var fromDate = Date()
    var toDate = Date()
    var titleName:String = ""
    
//    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var lblFileProcess: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var AllPictureCollectionView: UICollectionView!

    @IBAction func Back(){
        self.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        allImage = []
        finalIMAGE = []
        finalAsset = []
        assets = []
        FilterAsset = []
        FilterString = []
        allDataImage = []
        //  groupImage = []
//        listImageToDelle = []
       // AdmobManager.shared.logEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AllPictureCollectionView.register(UINib(nibName: "AllPictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllPictureCollectionViewCell")
        AllPictureCollectionView.dataSource = self
        AllPictureCollectionView.delegate = self

    }
    func getDataImage(){
        PhotoLibraryManager.shared.authorize(fromViewController: self) {[weak self] (authorized) -> Void in
            guard authorized == true else { return }
            self?.assets.removeAll()
            
            self?.assets.append(contentsOf: PhotoLibraryManager.shared.getAllImageAsset())
            // self?.convertPHAssetToUIImage(assets: self!.assets)
            
            self?.AllPictureCollectionView.reloadData()
        }
        workItem = DispatchWorkItem {
            for i in self.assets{
                if (self.workItem?.isCancelled)!{
                    break
                }
                let size = PhotoLibraryManager.shared.getSizeOfAsset(asset: i)
                self.fileProces = self.fileProces + 1
                DispatchQueue.main.async {
                    self.lblFileProcess.text = "File \(self.fileProces) / \(self.assets.count)"
                    self.AllPictureCollectionView.reloadData()
                    //                            self.lblNum.text = String(self.fileProces)
                }
            }
            DispatchQueue.main.async {
                self.AllPictureCollectionView.reloadData()
                //               self.viewIndicator.isHidden = true
                //               self.btnBackLoading.isHidden = true
                self.lblFileProcess.isHidden = true
            }
            
        }
        DispatchQueue.global().async(execute: workItem!)
    }
    @IBAction func ac_SelectAll(_ sender: Any) {
        for i in 0 ..< dem{
            listImageToDelle.removeLast()
        }
        listImageToDelle.append(contentsOf: assets)
        dem = assets.count
        AllPictureCollectionView.reloadData()
    }
    @IBAction func ac_Delete(_ sender: Any) {
        
        // l???y v??? tr?? c???a n?? trong library
        let assetIdentifiers = listImageToDelle.map({ $0.localIdentifier})
        
        // chuy???n n?? v??? ki???u NSFastEnumeration ????? th???c hi???n xo?? d??? li???u
        let listDelete = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        
        // Th???c hi???n vi???c xo??. ki???m tra xem c?? th??nh c??ng hay kh??ng
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(listDelete)}, completionHandler: {
            [self] success, error in
            if success{
                print("Deleted!")
                DispatchQueue.main.async {
                  dismiss(animated: true, completion: nil)
                    AllPictureCollectionView.reloadData()
                }
                
            }
            else
            {
                print("Cannot delete data")
            }
        })
        
    }
}
extension AllPictureViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPictureCollectionViewCell", for: indexPath) as! AllPictureCollectionViewCell
        if listImageToDelle.contains(assets[indexPath.row])
        {
            cell.imgTick.image = UIImage(named: "checkOk")
        }else
        {
            cell.imgTick.image = UIImage(named: "ic_unTick")
        }
        cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
        cell.isAccessibilityElement = true
        var asset: PHAsset!
        asset = assets[indexPath.row]
        cell.reloadCell(asset: asset)
        return cell

    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        return UICollectionReusableView()
    }

}

extension AllPictureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let index = listImageToDelle.firstIndex(of: assets[indexPath.row]){
            dem = dem - 1
            listImageToDelle.remove(at: index)
        }
        else
        {
            listImageToDelle.append(assets[indexPath.row])
            dem = dem + 1
        }
        AllPictureCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: self.AllPictureCollectionView.frame.width * 1/6 - 10 , height: self.AllPictureCollectionView.frame.width * 1/6)
        }
        return CGSize(width: self.AllPictureCollectionView.frame.width * 1/3 - 7 , height: self.AllPictureCollectionView.frame.width * 1/3)

    }
}
