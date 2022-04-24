//
//  CustomerReviewViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 23/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol CustomerReviewProtocolInput {
    func setup(orderId: Int?)
    func getOrderDescription()
    
    func didSelectItem(indexPath: IndexPath)
    func addListImage(image: UIImage, base64: String)
    
    func createReview(rate: Int, comment: String)
}

protocol CustomerReviewProtocolOutput: class {
    var didGetOrderDescriptionSuccess: (() -> Void)? { get set }
    var didSetImageSuccess: (() -> Void)? { get set }
    
    func getOrderDetailData() -> OrderDetailData?
    
    
    func getNumberOfCollection() -> Int
    func getItemViewCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

protocol CustomerReviewProtocol: CustomerReviewProtocolInput, CustomerReviewProtocolOutput {
    var input: CustomerReviewProtocolInput { get }
    var output: CustomerReviewProtocolOutput { get }
}

class CustomerReviewViewModel: CustomerReviewProtocol, CustomerReviewProtocolOutput {
    var input: CustomerReviewProtocolInput { return self }
    var output: CustomerReviewProtocolOutput { return self }
    
    // MARK: - Properties
    private var vc: CustomerReviewViewController
    
    // MARK: - Repo
    private var feedbackRepository: FeedbackRepository
    
    // MARK: - UseCase
    private var getOrderDescriptionUseCase: GetOrderDescriptionUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public var orderId: Int? = nil
    public var itemOrderDetail: OrderDetailData?
    
    fileprivate var listImage: [UIImage]? = []
    fileprivate var listImageBase64: [String]? = []
    
    var imagePicker: ImagePicker!
    
    init(
        vc: CustomerReviewViewController,
        getOrderDescriptionUseCase: GetOrderDescriptionUseCase = GetOrderDescriptionUseCaseImpl(),
        feedbackRepository: FeedbackRepository = FeedbackRepositoryImpl()
    ) {
        self.vc = vc
        self.getOrderDescriptionUseCase = getOrderDescriptionUseCase
        self.feedbackRepository = feedbackRepository
    }
    
    // MARK - Data-binding OutPut
    var didGetOrderDescriptionSuccess: (() -> Void)?
    var didSetImageSuccess: (() -> Void)?

    func setup(orderId: Int?) {
        self.orderId = orderId
    }
    
    func getOrderDescription() {
        guard let orderId = self.orderId else { return }
        debugPrint("Non Order ID \(orderId)")
        self.vc.startLoding()
        self.getOrderDescriptionUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("getOrderDescription \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let dataDetail = resp?.data {
                self.itemOrderDetail = dataDetail
            }
            
            self.didGetOrderDescriptionSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getOrderDetailData() -> OrderDetailData? {
        return self.itemOrderDetail
    }
    
    func getNumberOfCollection() -> Int {
        guard let count = listImage?.count, count != 0 else { return 1 }
        return count + 1
    }
    
    func getItemViewCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Image1x1ChooseCollectionViewCell.identifier, for: indexPath) as! Image1x1ChooseCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Image1x1CollectionViewCell.identifier, for: indexPath) as! Image1x1CollectionViewCell
            cell.delegate = self
            cell.index = indexPath.row
            if let image =  self.listImage?[indexPath.row-1] {
                cell.imageView.image = image
            }
            return cell
        }
    }
    
    func didSelectItem(indexPath: IndexPath) {
        guard self.listImage?.count ?? 0 < 5 else {
            ToastManager.shared.toastCallAPI(title: "จำกัดไม่เกิน 5 รูปภาพ!")
            return
        }
        if indexPath.row == 0 {
            imagePicker = ImagePicker(presentationController: self.vc, sourceType: [.camera, .photoLibrary], delegate: self)
            imagePicker.present(from: self.vc.view)
        }
    }
    
    func addListImage(image: UIImage, base64: String) {
        self.listImage?.append(image)
        self.listImageBase64?.append(base64)
        self.didSetImageSuccess?()
    }
    
    func createReview(rate: Int, comment: String) {
        var request = PostCreateFeedbackRequest()
        request.orderId = self.orderId
        request.comment = comment
        request.rate = rate
        
        var listImageRequest: [FeedbackAttachsRequest] = []
        self.listImageBase64?.forEach({ base64 in
            var imageRequest = FeedbackAttachsRequest()
            imageRequest.del = 0
            imageRequest.imgPath = base64
            listImageRequest.append(imageRequest)
        })
        
        request.feedbackAttachs = listImageRequest
        
        
        self.feedbackRepository.createFeedback(request: request).sink { completion in
            debugPrint("postCreateFeedback \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if resp.success == true {
                self.vc.navigationController?.popViewController(animated: true)
            }
        }.store(in: &self.anyCancellable)
        
    }
}

extension CustomerReviewViewModel: Image1x1CollectionViewCellDelegate {
    
    private func deleteItem(index: Int){
        listImage?.remove(at: index - 1)
        listImageBase64?.remove(at: index - 1)
        self.didSetImageSuccess?()
    }
    
    func didDeleteAction(index: Int) {
        self.deleteItem(index: index)
    }
}


extension CustomerReviewViewModel: ImagePickerDelegate {
    func didSelectImage(image: UIImage?, imagePicker: ImagePicker, base64: String) {
        if let image = image {
            addListImage(image: image, base64: base64)
        }
    }
}
