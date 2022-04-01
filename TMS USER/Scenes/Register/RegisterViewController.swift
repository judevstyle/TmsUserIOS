//
//  RegisterViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 28/3/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces

public protocol RegisterViewControllerDelegate {
    func updateProfileSuccess()
}

class RegisterViewController: UIViewController {

    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var btnChooseImage: UIButton!
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var inputDisplayName: BorderLineTextField!
    @IBOutlet var inputShopName: BorderLineTextField!
    @IBOutlet var inputTel: BorderLineTextField!
    @IBOutlet var inputAddress: BorderLineTextView!
    @IBOutlet var btnSave: ButtonCustomColor!
    
    @IBOutlet var btnSelectAddress: ButtonCustomColor!
    var imagePicker: ImagePicker!
    fileprivate var imageAttachFilesBase64: String?
    
    private var locationAddressCoordinate: CLLocationCoordinate2D? = nil
    
    @IBOutlet var viewTopHeight: NSLayoutConstraint!
    
    public var delegate: RegisterViewControllerDelegate?
    
    lazy var viewModel: RegisterProtocol = {
        let vm = RegisterViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardObserver()
    }
    
    deinit {
       removeObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.output.getContentUpdateProfile() != nil {
            UIApplication.shared.statusBarStyle = .lightContent
            self.navigationController?.navigationBar.tintColor = .white
            viewTopHeight.constant = 16
        } else {
            self.navigationController?.navigationBar.tintColor = .Primary
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }

    
    func configure(_ interface: RegisterProtocol) {
        self.viewModel = interface
    }
    
    func setupUI() {
        thumbnailImageView.setRounded(rounded: thumbnailImageView.frame.width/2)
        
        inputTel.keyboardType = .numberPad
        
        btnChooseImage.setRounded(rounded: btnChooseImage.frame.width/2)
        btnChooseImage.addTarget(self, action: #selector(handleChooseImage), for: .touchUpInside)
        btnSave.setBackgroundColor(.Primary)
        btnSave.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        btnSelectAddress.addTarget(self, action: #selector(handleChooseLocation), for: .touchUpInside)
        
        checkContentUpdateProfile()
    }
    
    func checkContentUpdateProfile() {
        guard let content = viewModel.output.getContentUpdateProfile() else {
            inputDisplayName.text = ""
            inputShopName.text = ""
            inputTel.text = ""
            inputTel.isEnabled = true
            inputAddress.text = ""
            return
        }
        
        inputDisplayName.text = content.displayName ?? ""
        inputShopName.text = content.fname ?? ""
        inputTel.text = content.tel ?? ""
        inputTel.isEnabled = false
        inputTel.textColor = .gray
        inputAddress.text = content.address ?? ""
        
        if let lat = content.lat, let lng = content.lng {
            self.locationAddressCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
        
        if let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(content.avatar ?? "")") {
            thumbnailImageView.kf.setImageDefault(with: urlImage)
        } else {
            thumbnailImageView.image = UIImage(named: "placeholder")?.withRenderingMode(.alwaysOriginal)
        }
    }

}

// MARK:- Event
extension RegisterViewController {
    @objc func handleChooseImage() {
        imagePicker = ImagePicker(presentationController: self, sourceType: [.camera, .photoLibrary], delegate: self)
        imagePicker.present(from: self.view)
    }
    
    @objc func handleSave() {
        
        if viewModel.output.isUpdateProfile {
            guard let displayName = inputDisplayName.text, !displayName.isEmpty,
            let displayShop = inputShopName.text, !displayShop.isEmpty,
            let tel = inputTel.text, !tel.isEmpty,
            let location = self.locationAddressCoordinate,
            let address = inputAddress.text, !address.isEmpty else {
                ToastManager.shared.toastCallAPI(title: "กรอกข้อมูลไม่ครบถ้วน!")
                return
            }
            viewModel.input.confirmContent(displayName: displayName, displayShop: displayShop, tel: tel, address: address, location: location, imageBase64: self.imageAttachFilesBase64)
        } else {
            guard let displayName = inputDisplayName.text, !displayName.isEmpty,
            let displayShop = inputShopName.text, !displayShop.isEmpty,
            let tel = inputTel.text, !tel.isEmpty,
            let location = self.locationAddressCoordinate,
            let address = inputAddress.text, !address.isEmpty,
                  let base64 = self.imageAttachFilesBase64, !base64.isEmpty else {
                ToastManager.shared.toastCallAPI(title: "กรอกข้อมูลไม่ครบถ้วน!")
                return
            }
            viewModel.input.confirmContent(displayName: displayName, displayShop: displayShop, tel: tel, address: address, location: location, imageBase64: base64)
        }
    }
    
    @objc func handleChooseLocation() {
        NavigationManager.instance.pushVC(to: .selectCurrentLocation(delegate: self))
    }
}

// MARK: - Binding
extension RegisterViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetGeoCodeSuccess = didGetGeoCodeSuccess()
        viewModel.output.didRegisterSuccess = didRegisterSuccess()
        viewModel.output.didUpdateProfileSuccess = didUpdateProfileSuccess()
    }
    
    func didGetGeoCodeSuccess() -> ((String?) -> Void) {
        return { location in
            self.inputAddress.text = location
        }
    }
    
    func didRegisterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            NavigationManager.instance.setRootViewController(rootView: .mainApp, withNav: false, isTranslucent: true)
        }
    }
    
    func didUpdateProfileSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.checkContentUpdateProfile()
            self.delegate?.updateProfileSuccess()
            self.backToRoot()
        }
    }
}


extension RegisterViewController: ImagePickerDelegate {
    func didSelectImage(image: UIImage?, imagePicker: ImagePicker, base64: String) {
        thumbnailImageView.image = image
        imageAttachFilesBase64 = base64
    }
}

extension RegisterViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        bottomHeight.constant = keyboardHeight
    }
}

extension RegisterViewController: SelectCurrentLocationViewControllerDelegate {
    func didSubmitEditLocation(centerMapCoordinate: CLLocationCoordinate2D) {
        self.locationAddressCoordinate = centerMapCoordinate
        viewModel.input.didSelectLocation(centerMapCoordinate: centerMapCoordinate)
    }
}
