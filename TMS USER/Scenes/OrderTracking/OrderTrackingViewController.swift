//
//  OrderTrackingViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import UIKit
import GoogleMaps

class OrderTrackingViewController: UIViewController {

    // ViewModel
    lazy var viewModel: OrderTrackingProtocol = {
        let vm = OrderTrackingViewModel(orderTrackingViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    var mapView: GMSMapView!
    var listMarker: [GMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMap()
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
    }
    
    func configure(_ interface: OrderTrackingProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.input.getOrderTracking()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.fetchMapMarker()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }
    
}

// MARK: - setupView
extension OrderTrackingViewController {
    func setupUI(){
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func fetchMarkerMap(markers: [MarkerMapItems]?){
        self.listMarker.removeAll()
        
        markers?.enumerated().forEach({ (index, item) in
            let position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lng ?? 0.0)
            let marker = GMSMarker(position: position)
            marker.snippet = "\(index)"
            marker.isTappable = true
            marker.iconView =  MarkerMapView.instantiate(index: index, message: item.empName ?? "", imageUrl: item.empAvatar)
            marker.tracksViewChanges = true
            
            listMarker.append(marker)
        })
        
        self.listMarker.forEach({ item in
            item.map = self.mapView
        })
        
//        if let itemLast = markers?.last {
//            let locationLast: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: itemLast.lat ?? 13.663491595353403, longitude: itemLast.lng ?? 100.6061463206966)
//            mapView.animate(toLocation: locationLast)
//        }
    }
}

// MARK: - Binding
extension OrderTrackingViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetMapMarkerSuccess = didGetMapMarkerSuccess()
    }
    
    func didGetMapMarkerSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            let markers = weakSelf.viewModel.output.getMapMarkerResponse()
            weakSelf.fetchMarkerMap(markers: markers)
        }
    }
}
extension OrderTrackingViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let markerView = marker.iconView as? MarkerMapView else { return false }
        return viewModel.input.didSelectMarkerAt(mapView, marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        var lat = coordinate.latitude
        var lng = coordinate.longitude
        
        DispatchQueue.global().async {
            for i in 0...100 {
                lat = lat + 0.001
                lng = lng + 0.001
                self.listMarker[0] .position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
}
