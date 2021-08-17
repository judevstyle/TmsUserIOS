//
//  OrderTrackingViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import Foundation
import UIKit
import GoogleMaps
import Combine


protocol OrderTrackingProtocolInput {
    func getOrderTracking()
    func setOrderId(orderId: Int?)
    func didSelectMarkerAt(_ mapView: GMSMapView, marker: GMSMarker) -> Bool
    func fetchMapMarker()
    
    //TableView
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
    
    func callTelPhone()
}

protocol OrderTrackingProtocolOutput: class {
    var didGetOrderTrackingSuccess: (() -> Void)? { get set }
    var didGetShipmentDetailError: (() -> Void)? { get set }
    
    func getMapMarkerResponse() -> [MarkerMapItems]?
    
    var didGetMapMarkerSuccess: (() -> Void)? { get set }
    
    //TableView
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight(indexPath: IndexPath) -> CGFloat
    
    func getItemShipment() -> ShipmentItems?
    
    //Box2
    func getSumAllPrice() -> Int
    func getCountOrder() -> Int
    func getOrderId() -> String
}

protocol OrderTrackingProtocol: OrderTrackingProtocolInput, OrderTrackingProtocolOutput {
    var input: OrderTrackingProtocolInput { get }
    var output: OrderTrackingProtocolOutput { get }
}

class OrderTrackingViewModel: OrderTrackingProtocol, OrderTrackingProtocolOutput {
    
    var input: OrderTrackingProtocolInput { return self }
    var output: OrderTrackingProtocolOutput { return self }
    
    // MARK: - Properties
    private var getOrderDescriptionUseCase: GetOrderDescriptionUseCase
    private var orderTrackingViewController: OrderTrackingViewController
    
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(
        orderTrackingViewController: OrderTrackingViewController,
        getOrderDescriptionUseCase: GetOrderDescriptionUseCase = GetOrderDescriptionUseCaseImpl()
    ) {
        self.orderTrackingViewController = orderTrackingViewController
        self.getOrderDescriptionUseCase = getOrderDescriptionUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetOrderTrackingSuccess: (() -> Void)?
    var didGetShipmentDetailError: (() -> Void)?
    
    var didGetMapMarkerSuccess: (() -> Void)?
    
    private var listMapMarker: [MarkerMapItems]? = []
    public var itemOrderDetail: OrderDetailData?
    public var orderId: Int? = nil
    public var listOrderD: [OrderD]? = []
    public var itemShipment: ShipmentItems?
    public var itemCustomer: CustomerItems?
    
    func setOrderId(orderId: Int?) {
        self.orderId = orderId
    }
    
    func getOrderTracking() {
        guard let orderId = orderId else { return }
        self.orderTrackingViewController.startLoding()
        self.getOrderDescriptionUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("getOrderDescription \(completion)")
            self.orderTrackingViewController.stopLoding()
            
            switch completion {
            case .finished:
                break
            case .failure(_):
                ToastManager.shared.toastCallAPI(title: "GetOrderDescription failure")
                break
            }
            
        } receiveValue: { resp in
            
            if let dataDetail = resp?.data {
                self.itemOrderDetail = dataDetail
            }
            
            if let itemCustomer = resp?.data?.customer {
                self.itemCustomer = itemCustomer
                self.listMapMarker?.removeAll()
                
                //add Customer Marker
                var marker: MarkerMapItems = MarkerMapItems()
                marker.empName = itemCustomer.displayName ?? ""
                marker.empAvatar = itemCustomer.avatar
                marker.lat = itemCustomer.lat
                marker.lng = itemCustomer.lng
                self.listMapMarker?.append(marker)
                self.didGetMapMarkerSuccess?()
            }
            
            if let itemShipment = resp?.data?.shipments, itemShipment.count > 0 {
                self.itemShipment = itemShipment[0]
            }
            
            if let listOrderD = resp?.data?.orderD {
                self.listOrderD = listOrderD
            }
            
            ToastManager.shared.toastCallAPI(title: "GetOrderDescription finished")
            self.didGetOrderTrackingSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getItemShipment() -> ShipmentItems? {
        return self.itemShipment
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
        
        debugPrint("didSelectMarkerAt")
        
        return true
    }
    
    func getSumAllPrice() -> Int {
        var price = 0
        
        listOrderD?.forEach({ item in
            price += item.price ?? 0
        })
        
        return price
    }
    
    func getCountOrder() -> Int {
        return self.listOrderD?.count ?? 0
    }
    
    func getOrderId() -> String {
        return self.itemOrderDetail?.orderNo ?? ""
    }
    
    func callTelPhone() {
        guard let tel = self.itemCustomer?.tel else { return }
        guard let numberPhone = URL(string: "tel://" + "\(tel)") else { return }
        UIApplication.shared.open(numberPhone)
    }
    
}

//MARK:- Fetch Socket
extension OrderTrackingViewModel {
    
    func getMapMarkerResponse() -> [MarkerMapItems]? {
        return self.listMapMarker
    }
    
    func fetchMapMarker() {
        SocketHelper.shared.fetchTrackingByComp { result in
            switch result {
            case .success(let resp): break
//                self.dataMapMarker = resp
//                self.didGetMapMarkerSuccess?()
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

//MARK: - TableView
extension OrderTrackingViewModel {
    
    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.listOrderD?.count ?? 0
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
        cell.orderD = listOrderD?[indexPath.item]
        cell.selectionStyle = .none
        return cell
    }
    
    func getItemViewCellHeight(indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        //        NavigationManager.instance.pushVC(to: .orderDetail)
    }
}

extension OrderTrackingViewModel {
    @objc func dismissAlertController() {
        //        OrderTrackingViewController.dismiss(animated: true, completion: nil)
    }
}
