//
//  OrderTrackingViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import Foundation
import UIKit
import GoogleMaps


protocol OrderTrackingProtocolInput {
    func getOrderTracking()
    func didSelectMarkerAt(_ mapView: GMSMapView, marker: GMSMarker) -> Bool
    func fetchMapMarker()
}

protocol OrderTrackingProtocolOutput: class {
    var didGetOrderTrackingSuccess: (() -> Void)? { get set }
    var didGetShipmentDetailError: (() -> Void)? { get set }
    
    func getMapMarkerResponse() -> [MarkerMapItems]?
    
    var didGetMapMarkerSuccess: (() -> Void)? { get set }
}

protocol OrderTrackingProtocol: OrderTrackingProtocolInput, OrderTrackingProtocolOutput {
    var input: OrderTrackingProtocolInput { get }
    var output: OrderTrackingProtocolOutput { get }
}

class OrderTrackingViewModel: OrderTrackingProtocol, OrderTrackingProtocolOutput {
    
    var input: OrderTrackingProtocolInput { return self }
    var output: OrderTrackingProtocolOutput { return self }
    
    // MARK: - Properties
    //    private var getProductUseCase: GetProductUseCase
    private var orderTrackingViewController: OrderTrackingViewController
    
    
    
    init(
        //        getProductUseCase: GetProductUseCase = GetProductUseCaseImpl(),
        orderTrackingViewController: OrderTrackingViewController
    ) {
        //        self.getProductUseCase = getProductUseCase
        self.orderTrackingViewController = orderTrackingViewController
    }
    
    // MARK - Data-binding OutPut
    var didGetOrderTrackingSuccess: (() -> Void)?
    var didGetShipmentDetailError: (() -> Void)?
    
    var didGetMapMarkerSuccess: (() -> Void)?
    
    private var dataMapMarker: SocketMarkerMapResponse?
    
    func getOrderTracking() {

    }
    
    func didSelectMarkerAt(_ mapView: GMSMapView, marker: GMSMarker) -> Bool {
//        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
//        let customView = PopupMarkerMapView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width-16, height: 204))
//        alertController.view.addSubview(customView)
//        alertController.view.backgroundColor = .white
//        alertController.view.layer.cornerRadius = 8
//        alertController.view.layer.masksToBounds = true
//        alertController.view.translatesAutoresizingMaskIntoConstraints = false
//        alertController.view.heightAnchor.constraint(equalToConstant: customView.frame.height).isActive = true
//
//        customView.backgroundColor = .green
//
//
//        alertController.editingInteractionConfiguration
//
//        OrderTrackingViewController.present(alertController, animated: true) {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
//            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//        }
        
        return true
    }
}

//MARK:- Fetch Socket
extension OrderTrackingViewModel {
    
    func getMapMarkerResponse() -> [MarkerMapItems]? {
        return self.dataMapMarker?.data
    }
    
    func fetchMapMarker() {
        SocketHelper.shared.fetchTrackingByComp { result in
            switch result {
            case .success(let resp):
                self.dataMapMarker = resp
                self.didGetMapMarkerSuccess?()
            case .failure(_ ):
                break
            }
        }
        emitMapMarker()
    }
    
    private func emitMapMarker(){
        var request: SocketMarkerMapRequest = SocketMarkerMapRequest()
        request.compId = 1
        SocketHelper.shared.emitTrackingByComp(request: request) {
            debugPrint("requestTrackingByComp\(request)")
        }
    }
}

extension OrderTrackingViewModel {
    @objc func dismissAlertController() {
//        OrderTrackingViewController.dismiss(animated: true, completion: nil)
    }
}
