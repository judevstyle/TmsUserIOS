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
    
    func configure(_ interface: RegisterProtocol) {
        self.viewModel = interface
    }
    
    func setupUI() {
        thumbnailImageView.setRounded(rounded: thumbnailImageView.frame.width/2)
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
    }
    
    @objc func handleChooseLocation() {
        NavigationManager.instance.pushVC(to: .selectCurrentLocation(delegate: self))
    }
}

// MARK: - Binding
extension RegisterViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetGeoCodeSuccess = didGetGeoCodeSuccess()
    }
    
    func didGetGeoCodeSuccess() -> ((String?) -> Void) {
        return { location in
            self.inputAddress.text = location
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
        viewModel.input.didSelectLocation(centerMapCoordinate: centerMapCoordinate)
    }
}
