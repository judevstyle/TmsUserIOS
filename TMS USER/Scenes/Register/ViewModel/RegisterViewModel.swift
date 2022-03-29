//
//  RegisterViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 28/3/2565 BE.
//

import Foundation
import UIKit
import Combine
import GoogleMaps

protocol RegisterProtocolInput {
    func didSelectLocation(centerMapCoordinate: CLLocationCoordinate2D)
    func setSelectLocation(centerMapCoordinate: CLLocationCoordinate2D)
}

protocol RegisterProtocolOutput: class {
    var didGetGeoCodeSuccess: ((String?) -> Void)? { get set }

}

protocol RegisterProtocol: RegisterProtocolInput, RegisterProtocolOutput {
    var input: RegisterProtocolInput { get }
    var output: RegisterProtocolOutput { get }
}

class RegisterViewModel: RegisterProtocol, RegisterProtocolOutput {
    
    var input: RegisterProtocolInput { return self }
    var output: RegisterProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getGeocodePlaceUseCase: GetGeocodePlaceUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: RegisterViewController

    //Select Location
    public var centerMapCoordinate: CLLocationCoordinate2D? = nil
    
    var didGetGeoCodeSuccess: ((String?) -> Void)?
    
    //CheckBox

    
    init(
        vc: RegisterViewController,
        getGeocodePlaceUseCase: GetGeocodePlaceUseCase = GetGeocodePlaceUseCaseImpl()
    ) {
        self.vc = vc
        self.getGeocodePlaceUseCase = getGeocodePlaceUseCase
    }


}


//Location
extension RegisterViewModel {
    func setSelectLocation(centerMapCoordinate: CLLocationCoordinate2D) {
        self.centerMapCoordinate = centerMapCoordinate
    }
    
    func didSelectLocation(centerMapCoordinate: CLLocationCoordinate2D) {
        self.centerMapCoordinate = centerMapCoordinate
        self.getGeocodePlace()
    }
    
    private func getGeocodePlace() {
        guard let lat = self.centerMapCoordinate?.latitude, let lng = self.centerMapCoordinate?.longitude else { return }
        self.vc.startLoding()
        var request = GetGeocodePlaceRequest()
        request.latlng = "\(lat),\(lng)"
        self.getGeocodePlaceUseCase.execute(request: request).sink { completion in
            debugPrint("getGeocodePlaceUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp?.results?.first {
                let title = item.formattedAddress
                self.didGetGeoCodeSuccess?(title)
            }
        }.store(in: &self.anyCancellable)
    }
}
