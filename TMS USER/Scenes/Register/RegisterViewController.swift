//
//  RegisterViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 28/3/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces

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
        UIApplication.shared.statusBarStyle = .darkContent
        self.navigationController?.navigationBar.tintColor = .Primary
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
    }

}

// MARK:- Event
extension RegisterViewController {
    @objc func handleChooseImage() {
        imagePicker = ImagePicker(presentationController: self, sourceType: [.camera, .photoLibrary], delegate: self)
        imagePicker.present(from: self.view)
    }
    
    @objc func handleSave() {
        guard let displayName = inputDisplayName.text, !displayName.isEmpty,
        let displayShop = inputShopName.text, !displayShop.isEmpty,
        let tel = inputTel.text, !tel.isEmpty,
        let location = self.locationAddressCoordinate,
        let address = inputAddress.text, !address.isEmpty,
              let base64 = self.imageAttachFilesBase64, !base64.isEmpty else {
            ToastManager.shared.toastCallAPI(title: "กรอกข้อมูลไม่ครบถ้วน!")
            return
        }
        viewModel.input.register(displayName: displayName, displayShop: displayShop, tel: tel, address: address, location: location, imageBase64: base64)
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
    }
    
    func didGetGeoCodeSuccess() -> ((String?) -> Void) {
        return { location in
            self.inputAddress.text = location
        }
    }
    
    func didRegisterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            NavigationManager.instance.setRootViewController(rootView: .mainApp, withNav: false, isTranslucent: true)
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
