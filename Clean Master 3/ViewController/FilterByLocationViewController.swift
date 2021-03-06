//
//  AllPictureViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 29/12/2021.
//

import UIKit
import Photos


class FilterByLocationViewController: UIViewController {
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
    @IBOutlet weak var FilterByCollection: UICollectionView!

    @IBAction func Back(){
        self.dismiss(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FilterByCollection.register(UINib(nibName: "AllPictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllPictureCollectionViewCell")
        FilterByCollection.dataSource = self
        FilterByCollection.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
     //   lblFile.text = String(assets.count)
        listImageToDelle = []
        FilterByCollection.reloadData()
    }
    @IBAction func ac_selectALL(_ sender: Any) {
        listImageToDelle = []
        listImageToDelle.append(contentsOf: assets)
        FilterByCollection.reloadData()
      
    }
    @IBAction func ac_Delete(_ sender: Any) {
        
        // lấy vị trí của nó trong library
        let assetIdentifiers = listImageToDelle.map({ $0.localIdentifier})
        
        // chuyển nó về kiểu NSFastEnumeration để thực hiện xoá dữ liệu
        let listDelete = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        
        // Thực hiện việc xoá. kiểm tra xem có thành công hay không
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(listDelete)}, completionHandler: {
            [self] success, error in
            if success{
                print("Deleted!")
                DispatchQueue.main.async {
                  dismiss(animated: true, completion: nil)
                    FilterByCollection.reloadData()
                }
                
            }
            else
            {
                print("Cannot delete data")
            }
        })
        
    }
}
extension FilterByLocationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension FilterByLocationViewController: UICollectionViewDelegateFlowLayout {
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
        FilterByCollection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: self.FilterByCollection.frame.width * 1/6 - 10 , height: self.FilterByCollection.frame.width * 1/6)
        }
        return CGSize(width: self.FilterByCollection.frame.width * 1/3 - 7 , height: self.FilterByCollection.frame.width * 1/3)

    }
}
