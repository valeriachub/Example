//
//  TripCellController.swift
//  TripsIOS
//
//  Created by Valeria Chub on 20.01.2022.
//

import UIKit

final class TripCellController {
    
    private let viewModel: TripCellViewModel<UIImage>
    private var cell: TripCell?
    
    init(viewModel: TripCellViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCell", for: indexPath) as! TripCell
        self.cell = binded(cell)
        viewModel.loadImage()
        return cell
    }
    
    private func binded(_ cell: TripCell) -> TripCell {
        cell.countryLabel.text = viewModel.country
        cell.tripImageView.image = nil
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.tripImageView.image = image
        }
        
        return cell
    }
    
    func preload() {
        viewModel.loadImage()
    }
    
    func releaseCellForReuse() {
        viewModel.onImageLoad = nil
        viewModel.onImageLoadingStateChanged = nil
        cell = nil
        viewModel.cancelLoading()
    }
}
