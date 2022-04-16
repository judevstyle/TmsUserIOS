//
//  ProfileHistoryViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import UIKit
import HMSegmentedControl

class ProfileHistoryViewController: UIViewController {

    @IBOutlet var topNav: UIView!
    let segmentedControl = HMSegmentedControl()
    
    @IBOutlet var pageCollectionView: UICollectionView!
    
    // ViewModel
    lazy var viewModel: ProfileHistoryProtocol = {
        let vm = ProfileHistoryViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTopnav()
        setupPageCollectionView()
    }
    
    func configure(_ interface: ProfileHistoryProtocol) {
        self.viewModel = interface
    }
    
    func setupUI() {
    }
    
    private func setupTopnav() {

        segmentedControl.sectionTitles = [
            TopNavProfileHistoryType.waitApprove.rawValue,
            TopNavProfileHistoryType.waitShipping.rawValue,
            TopNavProfileHistoryType.success.rawValue,
            TopNavProfileHistoryType.reject.rawValue,
            TopNavProfileHistoryType.calcel.rawValue,
        ]
        
        segmentedControl.frame = CGRect(x: 0, y: 12, width: topNav.frame.width, height: 38)
        segmentedControl.selectionIndicatorLocation = .bottom
        segmentedControl.selectionIndicatorColor = .Primary
        segmentedControl.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin]
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.contentVerticalAlignment = .center
        segmentedControl.enlargeEdgeInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        segmentedControl.segmentEdgeInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.font: UIFont.PrimaryText(size: 18), NSAttributedString.Key.foregroundColor: UIColor.Primary]
        segmentedControl.titleTextAttributes = [NSAttributedString.Key.font: UIFont.PrimaryText(size: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        topNav.addSubview(segmentedControl)
    }
}

// MARK: - Binding
extension ProfileHistoryViewController {
    func bindToViewModel() {
    }
}

extension ProfileHistoryViewController {
    @objc func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        let selectedIndexPath = IndexPath(item: Int(selectedSegmentIndex), section: 0)
        pageCollectionView.scrollToItem(at: selectedIndexPath, at: .bottom, animated: true)
        didPageChange(index: Int(selectedSegmentIndex))
    }
}

//MARK:- PageCollectionView
extension ProfileHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func setupPageCollectionView() {

        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pageCollectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.sectionInsetReference = .fromSafeArea
        pageCollectionView.collectionViewLayout = layout
        pageCollectionView.contentInsetAdjustmentBehavior = .always
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.backgroundColor = .clear

        pageCollectionView.registerCell(identifier: ProfileHistoryCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfItemsInSection(collectionView, section: section)
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.output.getCellForItemAt(collectionView, indexPath: indexPath)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = view.frame.width
        let currentPage = UInt(pageCollectionView.contentOffset.x/pageWidth)
        segmentedControl.setSelectedSegmentIndex(currentPage, animated: true)
        didPageChange(index: Int(currentPage))
    }
    
    func didPageChange(index: Int) {
        viewModel.input.didPageChange(index, self.pageCollectionView)
    }
}
