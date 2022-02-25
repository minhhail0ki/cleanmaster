//
//  PhotoLibraryManager.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 30/12/2021.
//

import Foundation
import UIKit
import Photos
let mailSupport = "haia1k54th@gmail.com"
class PhotoLibraryManager: NSObject {

    static let shared = PhotoLibraryManager()
   
    var sizeAssets: [[String:String]] = []
    var videos: [PHAsset] = []

    let cachingImageManager = PHCachingImageManager.default()
   
    func authorize(_ status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(), fromViewController: UIViewController, completion: @escaping (_ authorized: Bool) -> Void) {
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.authorize(status, fromViewController: fromViewController, completion: completion)
                })
            })
        default: ()
        DispatchQueue.main.async(execute: { () -> Void in
            completion(false)
        })
        }
    }
    
    func getVideoAsset(id: String) -> PHAsset?{
        let ids = videos.map({$0.localIdentifier})
        if ids.contains(id){
            if let index = ids.firstIndex(of: id){
                return videos[index]
            }
        }
        return nil
    }

    func getCacheSizeOfAsset(asset: PHAsset) -> Int64{
        let ids = sizeAssets.map({$0["id"]})
        let sizes = sizeAssets.map({$0["size"]})
        if ids.contains(asset.localIdentifier){
            if let index = ids.firstIndex(of: asset.localIdentifier){
                return Int64(sizes[index]!)!
            }
        }
        let size = self.getSizeOfAsset(asset: asset)
        let data = ["id": asset.localIdentifier, "size": "\(size)"]
        sizeAssets.append(data)
        return size
    }
    
    func getAllVideoAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        for i in 0..<allVideos.count{
            videos.append(allVideos[i])
        }
        return videos
    }
    
    func getAllImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
       
        
       
        
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let allVideos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for i in 0..<allVideos.count{
            videos.append(allVideos[i])
        }
        return videos
    }
    
    
    
    func getTypeImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        
        
//        // lấy ra tất cả hình ảnh video selfies
//        // lấy ra bộ sưu tập của nó
//        let selfiesAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil).firstObject!
//        let selfiesImage = PHAsset.fetchAssets(in: selfiesAlbum, options: nil)
//        print(selfiesImage.count)
//        for i in 0..<selfiesImage.count{
//           // print(allVideos[i])
//            videos.append(selfiesImage[i])
//        }
        
        
//        let liveAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLivePhotos, options: nil).firstObject!
//        let liveImageImage = PHAsset.fetchAssets(in: liveAlbum, options: nil)
//        print(liveImageImage.count)
//        for i in 0..<liveImageImage.count{
//           // print(allVideos[i])
//            videos.append(liveImageImage[i])
//        }
//
//        // Lấy ra giá trị của Screenshots
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject!
        let screenshotImage = PHAsset.fetchAssets(in: screenshotAlbum, options: nil)
        print(screenshotImage.count)
        for i in 0..<screenshotImage.count{
           // print(allVideos[i])
            videos.append(screenshotImage[i])
        }

        
        // lấy ra giá trị của Live photo
        fetchOptions.predicate = NSPredicate(format: "((mediaSubtype & %d) != 0)", PHAssetMediaSubtype.photoLive.rawValue)
        let allVideos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for i in 0..<allVideos.count{
            print(allVideos[i])
            
            videos.append(allVideos[i])
        }
        
        
        
        
        
        return videos
    }
    
    
    func getLiveImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLivePhotos, options: nil).firstObject!
        let screenshotImage = PHAsset.fetchAssets(in: screenshotAlbum, options: nil)
        print(screenshotImage.count)
        for i in 0..<screenshotImage.count{
           // print(allVideos[i])
            videos.append(screenshotImage[i])
        }
        
        return videos
    }
    
    
    func getScreenShotsImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

 
//        // Lấy ra giá trị của Screenshots
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject!
        let screenshotImage = PHAsset.fetchAssets(in: screenshotAlbum, options: nil)
        print(screenshotImage.count)
        for i in 0..<screenshotImage.count{
           // print(allVideos[i])
            videos.append(screenshotImage[i])
        }
        
        return videos
    }
    
    
    
    func getSelfiesImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
//        // lấy ra tất cả hình ảnh video selfies
//        // lấy ra bộ sưu tập của nó
        let selfiesAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil).firstObject!
        let selfiesImage = PHAsset.fetchAssets(in: selfiesAlbum, options: nil)
        print(selfiesImage.count)
        for i in 0..<selfiesImage.count{
           // print(allVideos[i])
            videos.append(selfiesImage[i])
        }
        
        return videos
    }
    
    func getFavouriteImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

 
//        // Lấy ra giá trị của Screenshots
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil).firstObject!
        let screenshotImage = PHAsset.fetchAssets(in: screenshotAlbum, options: nil)
        print(screenshotImage.count)
        for i in 0..<screenshotImage.count{
           // print(allVideos[i])
            videos.append(screenshotImage[i])
        }
        
        return videos
    }
    
    func getgifImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

 
//        // Lấy ra giá trị của Screenshots
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumAnimated, options: nil).firstObject!
        let screenshotImage = PHAsset.fetchAssets(in: screenshotAlbum, options: nil)
        print(screenshotImage.count)
        for i in 0..<screenshotImage.count{
           // print(allVideos[i])
            videos.append(screenshotImage[i])
        }
        
        return videos
    }
    
    
    
    
    
    
    func getLocationImageAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        
        
//        // lấy ra tất cả hình ảnh video selfies
//        // lấy ra bộ sưu tập của nó
//        let selfiesAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil).firstObject!
//        let selfiesImage = PHAsset.fetchAssets(in: selfiesAlbum, options: nil)
//        print(selfiesImage.count)
//        for i in 0..<selfiesImage.count{
//           // print(allVideos[i])
//            videos.append(selfiesImage[i])
//        }
        
        
//        let liveAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLivePhotos, options: nil).firstObject!
//        let liveImageImage = PHAsset.fetchAssets(in: liveAlbum, options: nil)
//        print(liveImageImage.count)
//        for i in 0..<liveImageImage.count{
//           // print(allVideos[i])
//            videos.append(liveImageImage[i])
//        }
//
//        // Lấy ra giá trị của Screenshots
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject!
        let screenshotImage = PHAsset.fetchAssets(in: screenshotAlbum, options: nil)
        
        print(screenshotImage.count)
        for i in 0..<screenshotImage.count{
           print(screenshotImage[i].localIdentifier)
            print(screenshotImage[i].creationDate ?? "0")
           // print(allVideos[i])
            videos.append(screenshotImage[i])
        }

        
        // lấy ra giá trị của Live photo
        fetchOptions.predicate = NSPredicate(format: "((mediaSubtype & %d) != 0)", PHAssetMediaSubtype.photoLive.rawValue)
        let allVideos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for i in 0..<allVideos.count{
            print(allVideos[i])
            
            videos.append(allVideos[i])
        }
        
        
        
        
        
        return videos
    }
    
    
    
//    func getLocation(){
//        // Specify the place data types to return (in this case, just photos).
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
//
//        placesClient?.fetchPlace(fromPlaceID: "INSERT_PLACE_ID_HERE",
//                                 placeFields: fields,
//                                 sessionToken: nil, callback: {
//          (place: GMSPlace?, error: Error?) in
//          if let error = error {
//            print("An error occurred: \(error.localizedDescription)")
//            return
//          }
//          if let place = place {
//            // Get the metadata for the first photo in the place photo metadata list.
//            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
//
//            // Call loadPlacePhoto to display the bitmap and attribution.
//            self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
//              if let error = error {
//                // TODO: Handle the error.
//                print("Error loading photo metadata: \(error.localizedDescription)")
//                return
//              } else {
//                // Display the first image and its attributions.
//                self.imageView?.image = photo;
//                self.lblText?.attributedText = photoMetadata.attributions;
//              }
//            })
//          }
//        })
//    }
    
    
    
    
    
    
    func getalbumfor()
    {
        let options = PHFetchOptions()
            // Bug from Apple since 9.1, use workaround
            //options.predicate = NSPredicate(format: "title = %@", albumName)
            options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true) ]

        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)

            for k in 0 ..< collection.count {
                let obj:AnyObject! = collection.object(at: k)
                if obj.title == "demo" {
                    print(String(obj.title))
                    if let assCollection = obj as? PHAssetCollection {
                        let results = PHAsset.fetchAssets(in: assCollection, options: options)
                        var assets = [PHAsset]()

                        results.enumerateObjects { (obj, index, stop) in

                            if let asset = obj as? PHAsset {
                                assets.append(asset)
                            }
                        }

                     //   return assets
                    }
                }
            }
    }
    
    
    
    func getAllAlbumAsset() -> [PHAsset]{
        videos.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = nil
        let allVideos = PHAsset.fetchAssets(with: fetchOptions)
        for i in 0..<allVideos.count{
            videos.append(allVideos[i])
        }
        return videos
    }

    func deleteVideoAssets(assetIds:[String], completion: @escaping (_ success: Bool) -> Void){
        var indexesToRemove: [Int] = []
        let ids = self.videos.map({$0.localIdentifier})
        var deleteAssets:[PHAsset] = []
       
        for id in assetIds{
            if let asset = self.getVideoAsset(id: id){
                deleteAssets.append(asset)
            }
            if ids.contains(id){
                if let index = ids.firstIndex(of: id){
                    indexesToRemove.append(index)
                }
            }
        }
        
        PHPhotoLibrary.shared().performChanges( {
            PHAssetChangeRequest.deleteAssets(deleteAssets as NSFastEnumeration)},
                                                            completionHandler: {
                                                                [weak self] success, error in
                                                                if success{
                                                                    if let temp = self?.videos{
                                                                        self?.videos = temp
                                                                            .enumerated()
                                                                            .filter { !indexesToRemove.contains($0.offset) }
                                                                            .map { $0.element }
                                                                    }
                                                                }
                                                                print(success)
                                                                completion(success)
        })
    }
    
    func fetchCollection(type: PHAssetCollectionType, subType: PHAssetCollectionSubtype = .any, fetchOptions:PHFetchOptions = PHFetchOptions()) -> PHFetchResult<PHAssetCollection>{
       
        let albumResult = PHAssetCollection.fetchAssetCollections(with: type, subtype: subType, options: fetchOptions)
        
        return albumResult
    }
    
    func fetchAssetInCollection(collection: PHAssetCollection, fetchOptions: PHFetchOptions = PHFetchOptions())  -> PHFetchResult<PHAsset>{
        let result = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        return result
    }
    
    func getSizeOfAsset(asset: PHAsset) -> Int64{
        let resources = PHAssetResource.assetResources(for: asset)
        
        var sizeOnDisk: Int64 = 0
        
        if let resource = resources.first {
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
        }
        return sizeOnDisk
    }
  
    func getSizeText(asset: PHAsset) -> String{
        let size = self.getCacheSizeOfAsset(asset: asset)
        let formatter:ByteCountFormatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(size))
    }
    
    func defaultAssetInCollectionOption() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        return fetchOptions
    }
    
//    func fetchImageInAlbum(album: PHAssetCollection){
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [
//            NSSortDescriptor(key: "creationDate", ascending: false)
//        ]
//        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//
//        let scale = UIScreen.main.scale
//        var width = (DEVICE_WIDTH - 10)/3
//        if IS_IPAD{
//            width = (DEVICE_WIDTH - 15)/4
//        }
//
//        let imageSize = CGSize(width: width * scale, height: width * scale)
//        let imageContentMode: PHImageContentMode = .aspectFill
//        let result = PHAsset.fetchAssets(in: album, options: fetchOptions)
//        result.enumerateObjects({ (asset, idx, stop) in
//            switch idx {
//            case 0:
//                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//                }
//            case 1:
//                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//                }
//            case 2:
//                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//                }
//
//            default:
//                // Stop enumeration
//                stop.initialize(to: true)
//            }
//        })
//    }
}
extension PHAsset {
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            option.isNetworkAccessAllowed = true
            manager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            return thumbnail
        }
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    func getUIImage(completionHandle: @escaping (UIImage?) -> ()){

        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        option.resizeMode = .exact
        option.deliveryMode = .highQualityFormat
        let _ = Int(PhotoLibraryManager.shared.cachingImageManager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) {(result, _) in
            completionHandle(result)
        })
    }
}

