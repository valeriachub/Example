//
//  TripViewControllerTests.swift
//  TripsIOSTests
//
//  Created by Valeria Chub on 19.01.2022.
//

import XCTest
import UIKit
import TripsIOS
import Tripper

class TripViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadTrips() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_loadTripActions_loadTripsFromLoader() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1)
        
        sut.simulateUserInitiateTripsReload()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserInitiateTripsReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingTrips() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        
        loader.completeLoadSuccessfully(with: [], at: 0)
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
        
        sut.simulateUserInitiateTripsReload()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        
        loader.completeLoadSuccessfully(with: [], at: 1)
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
        
        sut.simulateUserInitiateTripsReload()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        
        loader.completeLoad(with: anyNSError(), at: 2)
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
        
    func test_loadTripCompletion_rendersSuccessfullyLoadedTrips() {
        let tripA = makeTrip(country: "Netherlands")
        let tripB = makeTrip(country: "France")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeLoadSuccessfully(with: [tripA])
        assertThat(sut, isRendering: [tripA])
        
        loader.completeLoadSuccessfully(with: [tripA, tripB])
        assertThat(sut, isRendering: [tripA, tripB])
    }
    
    func test_loadTripCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let tripA = makeTrip(country: "Netherlands")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [tripA])
        assertThat(sut, isRendering: [tripA])
        
        sut.simulateUserInitiateTripsReload()
        loader.completeLoad(with: anyNSError())
        assertThat(sut, isRendering: [tripA])
    }
    
    func test_tripView_loadImageDataWhenVisisble() {
        let tripA = makeTrip(country: "Netherlands")
        let tripB = makeTrip(country: "France")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [tripA, tripB])
        
        XCTAssertEqual(loader.requestedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateTripVisible(at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [tripA.imageURL])
        
        sut.simulateTripVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [tripA.imageURL, tripB.imageURL])
    }
    
    func test_tripView_cancelImageDataLoadingWhenNotVisisbleAnymore() {
        let tripA = makeTrip(country: "Netherlands")
        let tripB = makeTrip(country: "France")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [tripA, tripB])
        XCTAssertEqual(loader.cancelledImageURLs, [])

        sut.simulateTripNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [tripA.imageURL])
        
        sut.simulateTripNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [tripA.imageURL, tripB.imageURL])
    }
    
    func test_tripView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [makeTrip(), makeTrip()])
        
        let view0 = sut.simulateTripVisible(at: 0)
        let view1 = sut.simulateTripVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, nil)
        XCTAssertEqual(view1?.renderedImage, nil)
        
        let image0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoadSuccessfully(with: image0, at: 0)
        XCTAssertEqual(view0?.renderedImage, image0)
        XCTAssertEqual(view1?.renderedImage, nil)

        let image1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoadSuccessfully(with: image1, at: 1)
        XCTAssertEqual(view0?.renderedImage, image0)
        XCTAssertEqual(view1?.renderedImage, image1)
    }
    
    func test_tripView_preloadImageURLWhenViewNearVisible() {
        let tripA = makeTrip(country: "Netherlands")
        let tripB = makeTrip(country: "France")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [tripA, tripB])
        
        XCTAssertEqual(loader.requestedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateTripNearVisible(at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [tripA.imageURL])
        
        sut.simulateTripNearVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [tripA.imageURL, tripB.imageURL])
    }
    
    func test_tripView_cancelPreloadImageURLWhenViewNotNearVisibleAnymore() {
        let tripA = makeTrip(country: "Netherlands")
        let tripB = makeTrip(country: "France")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [tripA, tripB])
        XCTAssertEqual(loader.cancelledImageURLs, [])
        
        sut.simulateTripNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [tripA.imageURL])
        
        sut.simulateTripNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [tripA.imageURL, tripB.imageURL])
    }
    
    func test_tripView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoadSuccessfully(with: [makeTrip()])
        
        let view = sut.simulateTripNotVisible(at: 0)
        loader.completeImageLoadSuccessfully(with: UIImage.make(withColor: .red).pngData()!)
        
        XCTAssertNil(view?.renderedImage)
    }
    
    func test_tripLoadCompletion_dispathcesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLoadSuccessfully(with: [makeTrip()])
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_tripImageLoadCompletion_dispathcesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeLoadSuccessfully(with: [makeTrip()])
        sut.simulateTripVisible(at: 0)

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoadSuccessfully(with: UIImage.make(withColor: .red).pngData()!)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TripsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = TripsUIComposer.tripsComposedWith(loader: loader, imageLoader: loader)
        trackMemoryLeak(on: loader, file: file, line: line)
        trackMemoryLeak(on: sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func trackMemoryLeak(on instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) should be deallocated", file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: TripsViewController, isRendering trips: [Trip], file: StaticString = #file, line: UInt = #line) {
        
        guard sut.numberOfRenderedTripViews() == trips.count else {
            return XCTFail("Expected \(trips.count) trips, got \(sut.numberOfRenderedTripViews())) instead", file: file, line: line)
        }
        
        XCTAssertEqual(sut.numberOfRenderedTripViews(), trips.count, file: file, line: line)
        
        trips.enumerated().forEach { index, trip in
            assertThat(sut, configureViewFor: trip, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: TripsViewController, configureViewFor trip: Trip, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.tripView(at: index)
        
        guard let cell = view as? TripCell else {
            return XCTFail("Expected \(TripCell.self) instance, got \(String.init(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertNotNil(cell, file: file, line: line)
        XCTAssertEqual(cell.countryText, trip.country, file: file, line: line)
    }
}
