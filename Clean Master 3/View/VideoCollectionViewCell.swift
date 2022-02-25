//
//  VideoCollectionViewCell.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 29/12/2021.
//

import UIKit
import Photos

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labeltime: UILabel!
    @IBOutlet weak var labelmb: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    let option = PHImageRequestOptions()
    @IBOutlet weak var imgChild: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // imgChild.layer.cornerRadius = 30.0
        self.imgChild.layer.cornerRadius = 10
        imgChild.layer.masksToBounds = true
       // print("huuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu\(UIScreen.main.scale),\(self.bounds.size.width)")
        option.isNetworkAccessAllowed = true
    }
    func reloadCell(asset: PHAsset){
        if self.tag != 0 {
            PhotoLibraryManager.shared.cachingImageManager.cancelImageRequest(PHImageRequestID(self.tag))
        }
        labeltime.text = "\(Int(asset.duration).toMinString)"
        if Int(asset.duration).toMinString == "00:00"{
            labeltime.text = ""
        }
        let scale = UIScreen.main.scale
        let imageSize = CGSize.init(width: self.bounds.size.width * scale, height: self.bounds.size.width * scale)
        self.tag = Int(PhotoLibraryManager.shared.cachingImageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: option) { (result, _) in
            self.imgChild.image = result
        })
       // self.sizeLabel.text = PhotoLibraryManager.shared.getSizeText(asset: asset)
    }
}
