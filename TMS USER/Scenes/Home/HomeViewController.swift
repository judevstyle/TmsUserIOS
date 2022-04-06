//
//  HomeViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var searchBar: UISearchBar!
    var badgeCount: UILabel!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var bgTopView: UIView!
    
    @IBOutlet var headerCollectionView: UICollectionView!
    @IBOutlet var productCollectionView: UICollectionView!
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 2
    
    // ViewModel
    lazy var viewModel: HomeProtocol = {
        let vm = HomeViewModel(homeViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBadge()
        viewModel.input.getCategory()
    }
    
    
    func configure(_ interface: HomeProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupValueBadge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hideKeyboardWhenSearch()
    }
}

// MARK: - Binding
extension HomeViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetCategorySuccess = didGetCategorySuccess()
        viewModel.output.didGetProductSuccess = didGetProductSuccess()
        viewModel.output.didUpdateCartBadge = didUpdateCartBadge()
    }
    
    func didGetCategorySuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.headerCollectionView.reloadData()
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            weakSelf.headerCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        }
    }
    
    func didGetProductSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.productCollectionView.reloadData()
        }
    }
    
    func didUpdateCartBadge() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            let objs = OrderCartManager.sharedInstance.getProductCart()
            weakSelf.badgeCount.text = "\(objs?.count ?? 0)"
        }
    }
}

extension HomeViewController {
    
    func setupUI() {
        hideKeyboardWhenTappedAround()
        NavigationManager.instance.setupWithNavigationController(self)
        //searchBar
        let customFrame = CGRect(x: 0, y: 0, width: 0, height: 44.0)
        searchBar = UISearchBar(frame: customFrame)
        searchBar.delegate = self
        searchBar.placeholder = "ค้นหาสินค้า ... "
        searchBar.compatibleSearchTextField.textColor = UIColor.Primary
        searchBar.compatibleSearchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.isEnabled = true
        searchBar.searchTextField.font = UIFont.PrimaryText(size: 17)
        searchBar.tintColor = .Primary
        searchBar.searchTextField.textColor = .Primary
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.PrimaryText(size: 17)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.PrimaryText(size: 17)
        
        self.navigationItem.titleView = searchBar
        
        
        topView.setRounded(rounded: 5)
        bgTopView.setRounded(rounded: 5)
        bgTopView.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                        locations: [0.5, 1.0],
                                        direction: .leftToRight,
                                        cornerRadius: 5)
        
        registerHeaderCell()
        registerProductCell()
    }
    
    func setupBadge() {
        badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .red
        
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightBarButton.setBackgroundImage(UIImage(systemName: "cart.fill"), for: .normal)
        rightBarButton.addTarget(self, action: #selector(self.addTapped), for: .touchUpInside)
        rightBarButton.tintColor = UIColor.white
        rightBarButton.addSubview(badgeCount)
        
        let rightBarButtomItem = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = rightBarButtomItem
    }
    
    func setupValueBadge() {
        let objs = OrderCartManager.sharedInstance.getProductCart()
        let count = Int("\(objs?.count ?? 0)") ?? 0
        if count > 0 {
            badgeCount.text = "\(objs?.count ?? 0)"
            badgeCount.isHidden = false
        } else {
            badgeCount.isHidden = true
        }
    }
    
    @objc func handleTapSearch(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
    }
    
    fileprivate func registerHeaderCell() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        headerCollectionView.showsVerticalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        headerCollectionView.collectionViewLayout = layout
        headerCollectionView.registerCell(identifier: ProductCategoryCollectionViewCell.identifier)
    }
    
    
    fileprivate func registerProductCell() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        productCollectionView.showsVerticalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        productCollectionView.collectionViewLayout = layout
        productCollectionView.registerCell(identifier: ProductCollectionViewCell.identifier)
    }
}

extension HomeViewController {
    @objc func addTapped() {
        NavigationManager.instance.pushVC(to: .productCart(dismiss: {
            self.setupValueBadge()
        }), presentation: .ModelNav(completion: {
        }, isFullScreen: true))
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.input.editingSearch(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.getProduct()
        self.searchBar.endEditing(true)
    }
}


extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case headerCollectionView:
            self.viewModel.input.didSelectItemAt(collectionView, indexPath: indexPath, type: .category)
        case productCollectionView:
            self.viewModel.input.didSelectItemAt(collectionView, indexPath: indexPath, type: .product)
        default:
            self.viewModel.input.didSelectItemAt(collectionView, indexPath: indexPath, type: .product)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case headerCollectionView:
            return self.viewModel.output.getItemViewCell(collectionView, indexPath: indexPath, type: .category)
        case productCollectionView:
            return self.viewModel.output.getItemViewCell(collectionView, indexPath: indexPath, type: .product)
        default:
            return self.viewModel.output.getItemViewCell(collectionView, indexPath: indexPath, type: .category)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case headerCollectionView:
            return self.viewModel.output.getNumberOfCollection(type: .category)
        case productCollectionView:
            return self.viewModel.output.getNumberOfCollection(type: .product)
        default:
            return self.viewModel.output.getNumberOfCollection(type: .category)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case headerCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case productCollectionView:
            return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case headerCollectionView:
            return 0
        case productCollectionView:
            return minimumLineSpacing
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case headerCollectionView:
            return 0
        case productCollectionView:
            return minimumInteritemSpacing
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
    
        switch collectionView {
        case headerCollectionView:
            var sizeWidthHead: CGFloat = 0
            let font = UIFont.PrimaryText(size: 17)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let myText = viewModel.output.getTitleCategory(indexPath: indexPath)
            let sizeWidth = (myText as NSString).size(withAttributes: fontAttributes)
            sizeWidthHead = sizeWidth.width + 8 + 16 + 16 + 8
            return CGSize(width: sizeWidthHead, height: 60)
        case productCollectionView:
            return CGSize(width: itemWidth, height: itemWidth + 85)
        default:
            return CGSize(width: itemWidth, height: itemWidth + 85)
        }
    }
}

//Handle KeyBoard SearchEditing
extension HomeViewController {
    
    func hideKeyboardWhenSearch() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissSearchKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissSearchKeyboard() {
        searchBar.endEditing(true)
    }
}
