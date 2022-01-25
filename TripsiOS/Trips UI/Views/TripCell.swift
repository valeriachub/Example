//
//  TripCell.swift
//  TripsIOS
//
//  Created by Valeria Chub on 20.01.2022.
//

import UIKit

public final class TripCell: UICollectionViewCell {
    
    @IBOutlet private(set) public var tripImageView: UIImageView!
    @IBOutlet private(set) public var countryLabel: UILabel!
    @IBOutlet private(set) public var daysLabel: UILabel!
    @IBOutlet private(set) public var citiesLabel: UILabel!
    @IBOutlet private(set) public var placesLabel: UILabel!
    @IBOutlet private(set) public var picturesLabel: UILabel!
    public let imageContainer = UIView()
}
