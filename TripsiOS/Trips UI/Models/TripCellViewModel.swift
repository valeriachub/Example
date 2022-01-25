//
//  TripCellViewModel.swift
//  TripsIOS
//
//  Created by Valeria Chub on 20.01.2022.
//

import Foundation
import Tripper

final class TripCellViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    
    private var task: TripImageDataTask?
    private let imageLoader: TripImageDataLoader
    private let imageTransform: (Data) -> Image?
    private let model: Trip
    
    init(model: Trip, imageLoader: TripImageDataLoader, imageTransform: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransform = imageTransform
    }
    
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChanged: Observer<Bool>?
    
    var country: String {
        return model.country
    }
    var imageURL: URL {
        return model.imageURL
    }
    
    func loadImage() {
        onImageLoadingStateChanged?(true)
        task = imageLoader.load(from: model.imageURL) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: TripImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransform) {
            onImageLoad?(image)
        }
        onImageLoadingStateChanged?(false)
    }
    
    func cancelLoading() {
        task?.cancel()
    }
}
