//
//  TripsViewController.swift
//  TripsIOS
//
//  Created by Valeria Chub on 19.01.2022.
//

import Foundation
import UIKit

public final class TripsViewController: UIViewController {
    
    @IBOutlet public var scrollView: UIScrollView!
    @IBOutlet public weak var collectionView: CustomCollectionView!
    
    var trips = [TripCellController]() {
        didSet {
            collectionView.trips = trips
        }
    }
    var refreshController: TripsRefreshController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setupCollectionView()
        scrollView.refreshControl = refreshController?.refreshControl
        refreshController?.refresh()
    }
}

public class CustomCollectionView: UICollectionView {
    
    var trips = [TripCellController]() {
        didSet {
            reloadData()
        }
    }
    
    func setupCollectionView() {
//        setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        dataSource = self
        delegate = self
        prefetchDataSource = self
        register(UINib(nibName: "TripCell", bundle: Bundle(for: TripCell.self)), forCellWithReuseIdentifier: "TripCell")
    }
}

extension CustomCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return trips[indexPath.row].view(in: collectionView, for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        trips[indexPath.row].releaseCellForReuse()
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
           trips[indexPath.row].preload()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            trips[indexPath.row].releaseCellForReuse()
        }
    }
}
