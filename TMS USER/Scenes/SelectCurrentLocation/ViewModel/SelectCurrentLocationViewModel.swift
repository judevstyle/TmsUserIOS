//
//  SelectCurrentLocationViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 30/3/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol SelectCurrentLocationProtocolInput {
    func getAutoComplete(request: GetPlaceAutoCompleteRequest)
    func didSelectPlace(item: PlaceItem)
}

protocol SelectCurrentLocationProtocolOutput: class {
    var didStationFilterSuccess: (() -> Void)? { get set }
    var didStationFilterError: (() -> Void)? { get set }
    
    var didGetPlaceAutoCompleteSuccess: (() -> Void)? { get set }
    var didGetPlaceDetailSuccess: (() -> Void)? { get set }
    
    func getListResultPlace() -> [PlaceItem]
    func getLocationSelectedPlace() -> PlaceItem?
}

protocol SelectCurrentLocationProtocol: SelectCurrentLocationProtocolInput, SelectCurrentLocationProtocolOutput {
    var input: SelectCurrentLocationProtocolInput { get }
    var output: SelectCurrentLocationProtocolOutput { get }
}

class SelectCurrentLocationViewModel: SelectCurrentLocationProtocol, SelectCurrentLocationProtocolOutput {
    var input: SelectCurrentLocationProtocolInput { return self }
    var output: SelectCurrentLocationProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlaceAutoCompleteUseCase: GetPlaceAutoCompleteUseCase
    private var getPlaceDetailUseCase: GetPlaceDetailUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: SelectCurrentLocationViewController
    
    //Place
    public var listSearchResultPlace: [PlaceItem] = []
    public var dataLocationPlace: PlaceItem?
    
    init(
        vc: SelectCurrentLocationViewController,
        getPlaceAutoCompleteUseCase: GetPlaceAutoCompleteUseCase = GetPlaceAutoCompleteUseCaseImpl(),
        getPlaceDetailUseCase: GetPlaceDetailUseCase = GetPlaceDetailUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlaceAutoCompleteUseCase = getPlaceAutoCompleteUseCase
        self.getPlaceDetailUseCase = getPlaceDetailUseCase
    }
    
    // MARK - Data-binding OutPut
    var didStationFilterSuccess: (() -> Void)?
    var didStationFilterError: (() -> Void)?
    
    var didGetPlaceAutoCompleteSuccess: (() -> Void)?
    var didGetPlaceDetailSuccess: (() -> Void)?

}

extension SelectCurrentLocationViewModel {
    func getAutoComplete(request: GetPlaceAutoCompleteRequest) {
        self.vc.startLoding()
        self.getPlaceAutoCompleteUseCase.execute(request: request).sink { completion in
            debugPrint("getPlaceAutoCompleteUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listSearchResultPlace = items
                self.didGetPlaceAutoCompleteSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getListResultPlace() -> [PlaceItem] {
        if self.listSearchResultPlace.count > 5 {
            var items: [PlaceItem] = []
            self.listSearchResultPlace.enumerated().forEach({ index, item in
                if index < 5 {
                    items.append(item)
                }
            })
            return items
        } else {
            return self.listSearchResultPlace
        }
    }
    
    func didSelectPlace(item: PlaceItem) {
        guard let placeId = item.placeId else { return }
        getPlaceDetail(placeId: placeId)
    }
    
    private func getPlaceDetail(placeId: String) {
        self.vc.startLoding()
        var request: GetPlaceDetailRequest = GetPlaceDetailRequest()
        request.placeId = placeId
        self.getPlaceDetailUseCase.execute(request: request).sink { completion in
            debugPrint("getPlaceDetailUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.dataLocationPlace = item
                self.didGetPlaceDetailSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getLocationSelectedPlace() -> PlaceItem? {
        return self.dataLocationPlace
    }
}

