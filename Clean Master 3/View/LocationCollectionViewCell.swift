//
//  LocationCollectionViewCell.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 11/01/2022.
//

import UIKit
import MapKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var mapkit: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
