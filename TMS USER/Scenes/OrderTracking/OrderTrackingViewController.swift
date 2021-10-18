//
//  OrderTrackingViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import UIKit
import GoogleMaps

class OrderTrackingViewController: UIViewController {
    
    @IBOutlet var imagePosterView: UIImageView!
    @IBOutlet var titleNoText: UILabel!
    @IBOutlet var descText: UILabel!
    @IBOutlet var positionText: UILabel!
    
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnTel: UIButton!
    
    @IBOutlet var viewMapArea: UIView!
    
    @IBOutlet var topViewDetail: UIView!
    @IBOutlet var bottomViewDetail: UIView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var btnToggleProductView: UIButton!
    
    @IBOutlet var orderErrorDataText: UILabel!
    
    //Order Box2
    @IBOutlet var orderTitleNoText: UILabel!
    @IBOutlet var countOrderItemText: UILabel!
    @IBOutlet var orderAllSumText: UILabel!
    
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
        registerCell()
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
    }
    
    func configure(_ interface: OrderTrackingProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMap()
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
        
        imagePosterView.isHidden = true
        titleNoText.isHidden = true
        descText.isHidden = true
        positionText.isHidden = true
        btnTel.isHidden = true
        btnChat.isHidden = true
        orderErrorDataText.isHidden = false
        
        imagePosterView.setRounded(rounded: imagePosterView.frame.width/2)
        imagePosterView.contentMode = .scaleAspectFill
        
        btnTel.setRounded(rounded: 5)
        btnChat.setRounded(rounded: 5)
        
        btnChat.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btnTel.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        btnTel.imageEdgeInsets = UIEdgeInsets(top: 3, left: -3, bottom: 3, right: 3)
        btnChat.imageEdgeInsets = UIEdgeInsets(top: 3, left: -3, bottom: 3, right: 3)
        
        topViewDetail.setRounded(rounded: 8)
        topViewDetail.setShadowBoxView()
        
        bottomViewDetail.setRounded(rounded: 8)
        bottomViewDetail.setShadowBoxView()
        btnToggleProductView.addTarget(self, action: #selector(didToggleShowHideTableView), for: .touchUpInside)
        
        
        btnChat.addTarget(self, action: #selector(didTapChat), for: .touchUpInside)
        btnTel.addTarget(self, action: #selector(didTapTel), for: .touchUpInside)
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMapArea.frame.width, height: self.viewMapArea.frame.height), camera: camera)
        mapView.delegate = self
        self.viewMapArea.isUserInteractionEnabled = true
        self.viewMapArea.addSubview(mapView)
    }
    
    func fetchMarkerMap(markers: [MarkerMapItems]?){
        self.listMarker.removeAll()
        var locationMove: CLLocationCoordinate2D? = nil
        markers?.enumerated().forEach({ (index, item) in
            let position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lng ?? 0.0)
            let marker = GMSMarker(position: position)
            marker.snippet = "\(index)"
            marker.isTappable = true
            marker.iconView =  MarkerMapView.instantiate(index: index, message: item.empName ?? "", imageUrl: item.empAvatar)
            marker.tracksViewChanges = true
            
            listMarker.append(marker)
            
            if index == ((markers?.count ?? 0) - 1) {
                locationMove = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lng ?? 0.0)
            }
        })
        
        self.listMarker.enumerated().forEach({ (index, item) in
            item.map = self.mapView
            if index == (listMarker.count - 1), let location = locationMove {
                self.mapView.animate(toLocation: location)
            }
        })
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.registerCell(identifier: ProductListTableViewCell.identifier)
    }
    
    @objc func didToggleShowHideTableView() {
        
        tableView.isHidden = !tableView.isHidden
        
        if tableView.isHidden == true {
            btnToggleProductView.setImage(UIImage(systemName: "arrow.down.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnToggleProductView.tintColor = UIColor.Primary
        } else {
            btnToggleProductView.setImage(UIImage(systemName: "arrow.up.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnToggleProductView.tintColor = UIColor.Primary
        }
    }
    
    func setupBox1Value() {
        guard let item = viewModel.output.getItemShipment() else {
            imagePosterView.isHidden = true
            titleNoText.isHidden = true
            descText.isHidden = true
            positionText.isHidden = true
            btnTel.isHidden = true
            btnChat.isHidden = true
            orderErrorDataText.isHidden = false
            return }
        
        titleNoText.text = "Shipment No : \(item.shipmentNo ?? "")"
        
        if let employee = item.employees, employee.count > 0 {
            descText.text = "\(employee[0].empDisplayName ?? "")"
            positionText.text = "ตำแหน่ง \(employee[0].jobPositionId ?? 0)"
            setImage(url: employee[0].empAvatar)
        }
        
        orderErrorDataText.isHidden = true
        imagePosterView.isHidden = false
        titleNoText.isHidden = false
        descText.isHidden = false
        positionText.isHidden = false
        btnTel.isHidden = false
        btnChat.isHidden = false
        
    }
    
    func setupBox2Value() {
        orderTitleNoText.text = viewModel.output.getOrderNo()
        orderAllSumText.text = "฿\(viewModel.output.getSumAllPrice())"
        countOrderItemText.text = "จำนวน Item \(viewModel.output.getCountOrder()) ชนิด"
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(url ?? "")") else { return }
        imagePosterView.kf.setImageDefault(with: urlImage)
    }
    
    @objc func didTapChat() {
        viewModel.input.didTapChat()
    }

    @objc func didTapTel() {
        viewModel.input.callTelPhone()
    }
    
    func hideViewPopup() {
        topViewDetail.isHidden = true
        bottomViewDetail.isHidden = true
    }
}

// MARK: - Binding
extension OrderTrackingViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetMapMarkerSuccess = didGetMapMarkerSuccess()
        viewModel.output.didGetOrderTrackingSuccess = didGetOrderTrackingSuccess()
        viewModel.output.didGetOrderTrackingError = didGetOrderTrackingError()
    }
    
    func didGetMapMarkerSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            let markers = weakSelf.viewModel.output.getMapMarkerResponse()
            weakSelf.fetchMarkerMap(markers: markers)
        }
    }
    
    func didGetOrderTrackingSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupBox1Value()
            weakSelf.setupBox2Value()
            weakSelf.tableView.reloadData()
        }
    }
    
    func didGetOrderTrackingError() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.hideViewPopup()
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
        
//        DispatchQueue.global().async {
//
//        }
    }
    
}

extension OrderTrackingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight(indexPath: indexPath)
    }
}

extension OrderTrackingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section)
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.getNumberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
}
