//
//  SelectCurrentLocationViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 29/3/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces

public protocol SelectCurrentLocationViewControllerDelegate {
    func didSubmitEditLocation(centerMapCoordinate: CLLocationCoordinate2D)
}

class SelectCurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet var btnSelectLocation: ButtonCustomColor!
    @IBOutlet var bottomHeight: NSLayoutConstraint!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var marker: GMSMarker!
    var listMarker: [GMSMarker] = []
    
    @IBOutlet var inputSearchText: UITextField!
    @IBOutlet var tableView: UITableView!
    
    public var delegate: SelectCurrentLocationViewControllerDelegate?
    
    lazy var viewModel: SelectCurrentLocationProtocol = {
        let vm = SelectCurrentLocationViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardObserver()
    }
    
    func configure(_ interface: SelectCurrentLocationProtocol) {
        self.viewModel = interface
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupMap()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView.stopRendering()
        mapView = nil
    }
    
    deinit {
       removeObserver()
    }
    
    func setupUI() {
        setupTableView()
        setupSearchBar()
        
        btnSelectLocation.addTarget(self, action: #selector(handleSelectLocation), for: .touchUpInside)
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.viewMap.isUserInteractionEnabled = true
        self.viewMap.addSubview(mapView)
        self.viewMap.clipsToBounds = true
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func setupSearchBar() {
        self.navigationItem.titleView = nil
        //searchBar
        inputSearchText.backgroundColor = .white
        inputSearchText.setRounded(rounded: 8)
        inputSearchText.tintColor = .Primary
        inputSearchText.textColor = .darkGray
        inputSearchText.setPaddingLeft(padding: 30)
        inputSearchText.setPaddingRight(padding: 30)
        inputSearchText.font = UIFont.PrimaryBold(size: 16)
        inputSearchText.placeholder = ""
        inputSearchText.clearButtonMode = .always
        inputSearchText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.setRounded(rounded: 8)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibCellClassName: SearchResultTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.isHidden = true
    }

}

//Event
extension SelectCurrentLocationViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            var request: GetPlaceAutoCompleteRequest = GetPlaceAutoCompleteRequest()
            request.input = text
            viewModel.input.getAutoComplete(request: request)
        } else {
            tableView.fadeOut(0.2, onCompletion: {
                
            })
        }
    }
    
    @objc func handleSelectLocation() {
        if let centerMapCoordinate = self.listMarker.first?.position {
            self.delegate?.didSubmitEditLocation(centerMapCoordinate: centerMapCoordinate)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - Binding
extension SelectCurrentLocationViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetPlaceAutoCompleteSuccess = didGetPlaceAutoCompleteSuccess()
        viewModel.output.didGetPlaceDetailSuccess = didGetPlaceDetailSuccess()
    }

    
    func didGetPlaceAutoCompleteSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            if weakSelf.tableView.isHidden == true {
                weakSelf.tableView.fadeIn(0.2, onCompletion: {
                    
                })
            }
        }
    }
    
    func didGetPlaceDetailSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            guard let selectedPlace = weakSelf.viewModel.output.getLocationSelectedPlace() else { return }
            weakSelf.moveLocationToPlace(place: selectedPlace)
        }
    }
    
    private func moveLocationToPlace(place: PlaceItem) {
        guard let lat = place.geometry?.locationLat,
              let lng = place.geometry?.locationLng else { return }

        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView?.animate(to: camera)
        tableView.fadeOut()
    }
}

extension SelectCurrentLocationViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        bottomHeight.constant = keyboardHeight
    }
}

extension SelectCurrentLocationViewController : GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.listMarker.removeAll()
        self.mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.isTappable = false
        marker.icon = UIImage(named: "pin-marker")?.withRenderingMode(.alwaysOriginal)
        marker.tracksViewChanges = false
        marker.map = self.mapView
        self.listMarker.append(marker)

    }
    
    func placeMarkerOnCenter(centerMapCoordinate: CLLocationCoordinate2D) {
        if marker == nil {
            marker = GMSMarker()
        }
        marker.position = centerMapCoordinate
        marker.map = self.mapView
    }
}


extension SelectCurrentLocationViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 7.0, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

//TableView Delegate
extension SelectCurrentLocationViewController: UITableViewDelegate, UITableViewDataSource  {
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = viewModel.output.getListResultPlace().count
        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as! SearchResultTableViewCell
        let place = viewModel.output.getListResultPlace()[indexPath.item]
        cell.place = place
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = viewModel.output.getListResultPlace()[indexPath.item]
        viewModel.input.didSelectPlace(item: place)
    }
}
