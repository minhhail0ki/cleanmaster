//
//  VideoDetailViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 30/12/2021.
//

import UIKit
import Photos

class VideoDetailViewController: UIViewController {
    var listImageToDelle = [PHAsset]()
    var dem = 0
    
    var assets: [PHAsset] = []
    var Filterassets: [PHAsset] = []
    //@IBOutlet weak var viewIndicator: UIView!
//    @IBOutlet weak var lblNum: UILabel!
    @IBOutlet weak var VideoCollectionView: UICollectionView!
    @IBOutlet weak var lblFileProcess: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    
    var titleName:String = ""
    var totalFile = 0
    var fileProces = 0
    var workItem: DispatchWorkItem?
    var ID = 0

    @IBAction func Back(){
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        VideoCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        VideoCollectionView.dataSource = self
        VideoCollectionView.delegate = self
        
        lblTitle.text = titleName
    }
    override func viewWillAppear(_ animated: Bool) {
        listImageToDelle = []
       // AdmobManager.shared.logEvent()
    }

    override func viewDidAppear(_ animated: Bool) {
        getDataVideo()
        
    }
    func getDataVideo(){
        PhotoLibraryManager.shared.authorize(fromViewController: self) {[weak self] (authorized) -> Void in
            guard authorized == true else { return }
            self?.assets.removeAll()
            self?.assets =  (PhotoLibraryManager.shared.getAllVideoAsset())
            self?.getVideoBySize(assets: self!.assets)
         
           // self?.lblNum.text = String(self?.assets.count ?? 0)
        
            // Thực hiện chuyển nó sang dạng UIImage
          //  self?.convertPHAssetToUIImage(assets: self!.assets)
          
          self?.VideoCollectionView.reloadData()
        }
    }
    func getVideoBySize(assets: [PHAsset])
    {
        
        workItem = DispatchWorkItem {
            
           
            for i in assets{
                if (self.workItem?.isCancelled)!{
                            break
                        }
                
                let size = PhotoLibraryManager.shared.getSizeOfAsset(asset: i)
                if self.ID == 1{
                    if size > 500000000 {
                        self.Filterassets.append(i)
                        self.fileProces = self.fileProces + 1
                        DispatchQueue.main.async {
                            self.lblFileProcess.text = "File \(self.fileProces) / \(self.assets.count)"
                            self.VideoCollectionView.reloadData()
//                            self.lblNum.text = String(self.fileProces)
                        }
                    }
                }
                else if self.ID == 2{
                    if (size >= 100000000 && size <= 500000000) {
                        self.Filterassets.append(i)
                        self.fileProces = self.fileProces + 1
                        DispatchQueue.main.async {
                            self.lblFileProcess.text = "File \(self.fileProces) / \(self.assets.count)"
                            self.VideoCollectionView.reloadData()
//                            self.lblNum.text = String(self.fileProces)
                        }
                    }
                }
                else if self.ID == 3{
                    if size < 100000000 {
                        self.Filterassets.append(i)
                        self.fileProces = self.fileProces + 1
                        DispatchQueue.main.async {
                            self.lblFileProcess.text = "File \(self.fileProces) / \(self.assets.count)"
                            self.VideoCollectionView.reloadData()
//                            self.lblNum.text = String(self.fileProces)
                        }
                    }
                }
              
            }
              DispatchQueue.main.async {
               self.VideoCollectionView.reloadData()
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
        listImageToDelle.append(contentsOf: Filterassets)
        dem = Filterassets.count
        VideoCollectionView.reloadData()
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
                    VideoCollectionView.reloadData()
                }
                
            }
            else
            {
                print("Cannot delete data")
            }
        })
        
    }

}
extension VideoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filterassets.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell

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
        asset = Filterassets[indexPath.row]
        cell.reloadCell(asset: asset)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
}

extension VideoDetailViewController: UICollectionViewDelegateFlowLayout {
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
        
        
        VideoCollectionView.reloadData()
        print("hai")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: self.VideoCollectionView.frame.width * 1/6 - 10 , height: self.VideoCollectionView.frame.width * 1/6)
        }
        return CGSize(width: self.VideoCollectionView.frame.width * 1/3 - 7 , height: self.VideoCollectionView.frame.width * 1/3)
        
    }
}
