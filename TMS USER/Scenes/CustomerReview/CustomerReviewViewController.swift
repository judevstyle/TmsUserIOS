//
//  CustomerReviewViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 23/4/2565 BE.
//

import UIKit
import Foundation

class CustomerReviewViewController: UIViewController {
    //Box1
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var empCodeText: UILabel!
    @IBOutlet var orderNameText: UILabel!
    @IBOutlet var orderPositionText: UILabel!
    
    
    //Box2
    @IBOutlet var orderNoText: UILabel!
    @IBOutlet var countOrderText: UILabel!
    @IBOutlet var headBalanceText: UILabel!
    @IBOutlet var balanceText: UILabel!
    
    //Star
    @IBOutlet var btnVote: [UIButton]!
    
    @IBOutlet var inputTextComment: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    
    public var screenImageWidth: Double = 0
    
    @IBOutlet var btnSubmit: UIButton!
    // ViewModel
    lazy var viewModel: CustomerReviewProtocol = {
        let vm = CustomerReviewViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.getOrderDescription()
    }
    
    func configure(_ interface: CustomerReviewProtocol) {
        self.viewModel = interface
    }
    
    func setupUI() {
        self.empCodeText.font = .PrimaryBold(size: 18)
        self.empCodeText.textColor = .black
        
        self.orderNameText.font = .PrimaryBold(size: 16)
        self.orderNameText.textColor = .black
        
        self.orderPositionText.font = .PrimaryMedium(size: 14)
        self.orderPositionText.textColor = .darkGray
        
        
        //Box2
        self.orderNoText.font = .PrimaryBold(size: 18)
        self.orderNoText.textColor = .black
        
        self.countOrderText.font = .PrimaryMedium(size: 14)
        self.countOrderText.textColor = .darkGray
        
        self.headBalanceText.font = .PrimaryBold(size: 16)
        self.headBalanceText.textColor = .black
        
        self.balanceText.font = .PrimaryBold(size: 16)
        self.balanceText.textColor = .Primary
        
        //Star
        btnVote.enumerated().forEach({ index, btn in
            btn.contentVerticalAlignment = .fill
            btn.contentHorizontalAlignment = .fill
            btn.setImage(UIImage.init(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = .lightGray
            btn.tag = index
        })
        
        //Text Area
        self.inputTextComment.layer.borderColor = UIColor.lightGray.cgColor
        self.inputTextComment.layer.borderWidth = 1.0
        self.inputTextComment.layer.cornerRadius = 5
        self.inputTextComment.text = "แสดงความคิดเห็น หรือ ร้องเรียน"
        self.inputTextComment.textColor = UIColor.lightGray
        self.inputTextComment.font = .PrimaryMedium(size: 16)
        self.inputTextComment.delegate = self
        
        registerCell()
        
        setupButtonSubmit(button: self.btnSubmit, title: "ยืนยัน", action: #selector(self.didTapSubmit))
    }
    
    private func setupButtonSubmit(button: UIButton, title: String, action: Selector) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            button.setRounded(rounded: 8)
            button.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                         locations: [0.5, 1.0],
                                         direction: .leftToRight,
                                         cornerRadius: 8)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.textColor = .white
            button.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    @objc func didTapSubmit() {
        var rate: Int = 0
        let all = self.btnVote.count - 1
        for i in 0...all {
            if self.btnVote[i].isSelected == true {
                rate += 1
            }
        }
        let comment = self.inputTextComment.text == "แสดงความคิดเห็น หรือ ร้องเรียน" ? "" : self.inputTextComment.text
        viewModel.input.createReview(rate: rate, comment: comment ?? "")
    }
    
    func setupValue() {
        guard let order = viewModel.output.getOrderDetailData() else { return }
        //Box1
        self.empCodeText.text = order.shipmentsDetail?.employees?.first?.empCode ?? "-"
        self.orderNameText.text = order.shipmentsDetail?.employees?.first?.empDisplayName ?? "-"
        self.orderPositionText.text = "ตำแหน่ง -"
        self.setImage(url: order.shipmentsDetail?.employees?.first?.empAvatar)
        
        //Box2
        self.orderNoText.text = "Order No. : \(order.orderNo ?? "")"
        self.countOrderText.text = "\(order.orderD?.count ?? 0) อย่าง"
        
        self.headBalanceText.text = "รวมรายการสั่งซื้อ : "
        self.balanceText.text = "฿\(order.balance)"
        
        self.empCodeText.sizeToFit()
        self.orderNameText.sizeToFit()
        self.orderPositionText.sizeToFit()
        
        self.orderNoText.sizeToFit()
        self.countOrderText.sizeToFit()
        self.headBalanceText.sizeToFit()
        self.balanceText.sizeToFit()
    }
    
    fileprivate func registerCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        screenImageWidth = (collectionView.frame.width / 4.0) - 8
        collectionViewHeight.constant = screenImageWidth + 8
        layout.itemSize = CGSize(width: screenImageWidth, height: screenImageWidth)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        collectionView!.collectionViewLayout = layout
        collectionView.registerCell(identifier: Image1x1ChooseCollectionViewCell.identifier)
        collectionView.registerCell(identifier: Image1x1CollectionViewCell.identifier)
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        self.posterImage.kf.setImageDefault(with: urlImage)
    }
    
    @IBAction func handlebtnVote(_ sender: UIButton) {
    
        let all = self.btnVote.count - 1
        var lastOneOnly: Bool = false
        for i in 0...all {
            if self.btnVote[i].isSelected == true && i != 0 {
                lastOneOnly = false
            } else if self.btnVote[0].isSelected == true && i == 0  {
                lastOneOnly = true
            }
        }
        
        
        if sender.tag == 0 && lastOneOnly == true {
            sender.isSelected = !sender.isSelected
        } else {
            for i in 0...all {
                if i > sender.tag {
                    self.btnVote[i].isSelected = false
                } else {
                    self.btnVote[i].isSelected = true
                }
            }
            
            sender.isSelected = true
        }

        setColorStarButton()
    }
    
    func setColorStarButton() {
        self.btnVote.forEach({ sender in
            if sender.isSelected == true {
                sender.tintColor = .Primary
            } else {
                sender.tintColor = .lightGray
            }
        })
    }
    
    
    
}

// MARK: - Binding
extension CustomerReviewViewController {
    func bindToViewModel() {
        viewModel.output.didGetOrderDescriptionSuccess = didGetOrderDescriptionSuccess()
        viewModel.output.didSetImageSuccess = didSetImageSuccess()
    }
    
    func didGetOrderDescriptionSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.setupValue()
        }
    }
    
    func didSetImageSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
}

extension CustomerReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
              textView.text = nil
              textView.textColor = UIColor.darkGray
          }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "แสดงความคิดเห็น หรือ ร้องเรียน"
            textView.textColor = UIColor.lightGray
        }
    }
}


extension CustomerReviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didSelectItem(indexPath: indexPath)
    }
    
}

extension CustomerReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.output.getNumberOfCollection()
        let countColumn: Int = count/4
        let modCount: Double = Double(count%4)
        var roundedCount = countColumn
        if modCount == 0.0 {
        } else {
            roundedCount += 1
        }
        collectionViewHeight.constant = roundedCount > 1 ? ((screenImageWidth+8)*Double(roundedCount)) : (screenImageWidth + 8)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.output.getItemViewCell(collectionView, indexPath: indexPath)
    }
}

