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
    func register(displayName: String, displayShop: String, tel: String, address: String, location: CLLocationCoordinate2D, imageBase64: String)
    func checkTel(tel: String, completion: (() -> Void)?)
    func registerCustomer(displayName: String, displayShop: String, tel: String, address: String, location: CLLocationCoordinate2D, imageBase64: String)
}

protocol RegisterProtocolOutput: class {
    var didGetGeoCodeSuccess: ((String?) -> Void)? { get set }
    var didPostCheckTelSuccess: (() -> Void)? { get set }
    var didRegisterSuccess: (() -> Void)? { get set }
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
    private var postCheckTelUseCase: PostCheckTelUseCase
    private var postRegisterCustomerUseCase: PostRegisterCustomerUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: RegisterViewController
    
    //Select Location
    public var centerMapCoordinate: CLLocationCoordinate2D? = nil
    
    var didGetGeoCodeSuccess: ((String?) -> Void)?
    var didPostCheckTelSuccess: (() -> Void)?
    var didRegisterSuccess: (() -> Void)?
    
    init(
        vc: RegisterViewController,
        getGeocodePlaceUseCase: GetGeocodePlaceUseCase = GetGeocodePlaceUseCaseImpl(),
        postCheckTelUseCase: PostCheckTelUseCase = PostCheckTelUseCaseImpl(),
        postRegisterCustomerUseCase: PostRegisterCustomerUseCase = PostRegisterCustomerUseCaseImpl()
    ) {
        self.vc = vc
        self.getGeocodePlaceUseCase = getGeocodePlaceUseCase
        self.postCheckTelUseCase = postCheckTelUseCase
        self.postRegisterCustomerUseCase = postRegisterCustomerUseCase
    }
    
    
    func register(displayName: String, displayShop: String, tel: String, address: String, location: CLLocationCoordinate2D, imageBase64: String) {
        self.checkTel(tel: tel, completion: {
            self.registerCustomer(displayName: displayName, displayShop: displayShop, tel: tel, address: address, location: location, imageBase64: imageBase64)
        })
    }
    
    func checkTel(tel: String, completion: (() -> Void)?) {
        vc.startLoding()
        var request = PostAuthenticateRequest()
        request.tel = tel
        self.postCheckTelUseCase.execute(request: request).sink { completion in
            debugPrint("postCheckTelUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let msg = resp?.data?.msg, msg == "no Dupplicate" {
                completion?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func registerCustomer(displayName: String, displayShop: String, tel: String, address: String, location: CLLocationCoordinate2D, imageBase64: String) {
        vc.startLoding()
        var request = PostRegisterCustomerRequest()
        request.tel = tel
        request.displayName = displayName
        request.fname = displayShop
        request.lname = ""
        request.address = address
        request.lat = location.latitude
        request.lng = location.longitude
        var avatar = CustomerAvatar()
        avatar.url = imageBase64
        avatar.del = 1
        request.avatar = avatar
        self.postRegisterCustomerUseCase.execute(request: request).sink { completion in
            debugPrint("postRegisterCustomerUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp,
               item.success == true,
               let accessToken = item.data?.accessToken,
               let expireAccessToken = item.data?.expire {
                debugPrint(accessToken)
                UserDefaultsKey.AccessToken.set(value: accessToken)
                UserDefaultsKey.ExpireAccessToken.set(value: expireAccessToken)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.didRegisterSuccess?()
                }
            }
        }.store(in: &self.anyCancellable)
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
