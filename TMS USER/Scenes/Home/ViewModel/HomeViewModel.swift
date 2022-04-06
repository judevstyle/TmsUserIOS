//
//  HomeViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

protocol HomeProtocolInput {
    func getCategory()
    func getProduct()
    
    func editingSearch(_ search: String)
    
    func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath, type: TypeUserCollectionType)
    func didSelectCategory(index: Int)
    func didSelectProduct(index: Int)
}

protocol HomeProtocolOutput: class {
    var didGetCategorySuccess: (() -> Void)? { get set }
    var didGetProductSuccess: (() -> Void)? { get set }
    
    var didUpdateCartBadge: (() -> Void)? { get set }
    
    func getNumberOfCollection(type: TypeUserCollectionType) -> Int
    func getItem(index: Int) -> ProductItems?
    func getItemViewCell(_ collectionView: UICollectionView, indexPath: IndexPath, type: TypeUserCollectionType) -> UICollectionViewCell
    
    func getTitleCategory(indexPath: IndexPath) -> String
}

protocol HomeProtocol: HomeProtocolInput, HomeProtocolOutput {
    var input: HomeProtocolInput { get }
    var output: HomeProtocolOutput { get }
}

class HomeViewModel: HomeProtocol, HomeProtocolOutput {
    var input: HomeProtocolInput { return self }
    var output: HomeProtocolOutput { return self }
    
    // MARK: - Properties
    private var getProductTypeUseCase: GetProductTypeUseCase
    private var getProductUseCase: GetProductUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var homeViewController: HomeViewController
    
    init(
        homeViewController: HomeViewController,
        getProductTypeUseCase: GetProductTypeUseCase = GetProductTypeUseCaseImpl(),
        getProductUseCase: GetProductUseCase = GetProductUseCaseImpl()
    ) {
        self.homeViewController = homeViewController
        self.getProductTypeUseCase = getProductTypeUseCase
        self.getProductUseCase = getProductUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetCategorySuccess: (() -> Void)?
    var didGetProductSuccess: (() -> Void)?
    var didUpdateCartBadge: (() -> Void)?
    
    fileprivate var selectedIndex: Int = 0
    
    fileprivate var listCategory: [ProductType]? = []
    fileprivate var listProduct: [ProductItems]? = []
    public var searchText: String?
    public var productTypeId: Int?
    
    func getCategory() {
        listCategory?.removeAll()
        self.homeViewController.startLoding()
        self.getProductTypeUseCase.execute().sink { completion in
            debugPrint("getProductType \(completion)")
            self.homeViewController.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listCategory = items
            }
            self.didGetCategorySuccess?()
            self.didSelectCategory(index: 0)
        }.store(in: &self.anyCancellable)
    }
    
    func getProduct() {
        listProduct?.removeAll()
        self.homeViewController.startLoding()
        var request: GetProductRequest = GetProductRequest()
        request.compId = 1
        request.productTypeId = self.productTypeId
        request.search = self.searchText
        self.getProductUseCase.execute(request: request).sink { completion in
            debugPrint("getProduct \(completion)")
            self.homeViewController.stopLoding()
        } receiveValue: { resp in
            if let items = resp?.items {
                self.listProduct = items
            }
            self.didGetProductSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func didSelectCategory(index: Int) {
        self.selectedIndex = index
        switch index {
        case 0:
            self.productTypeId = nil
            getProduct()
            break
        default:
            let id = self.listCategory?[index - 1].productTypeId
            self.productTypeId = id
            getProduct()
        }
    }
    
    func getNumberOfCollection(type: TypeUserCollectionType) -> Int {
        switch type {
        case .category:
            return ((self.listCategory?.count ?? 0) + 1)
        default:
            return self.listProduct?.count ?? 0
        }
    }
    
    func getItem(index: Int) -> ProductItems? {
        guard let itemMenu = listProduct?[index] else { return nil }
        return itemMenu
    }
    
    func getItemViewCell(_ collectionView: UICollectionView, indexPath: IndexPath, type: TypeUserCollectionType) -> UICollectionViewCell {
        switch type {
        case .category:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCategoryCollectionViewCell.identifier, for: indexPath) as! ProductCategoryCollectionViewCell
            switch indexPath.item {
            case 0:
                var item = ProductType()
                item.productTypeName = "ทั้งหมด"
                cell.items = item
            default:
                cell.items = self.listCategory?[indexPath.item - 1]
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
            cell.itemsProduct = self.listProduct?[indexPath.item]
            cell.setShadowCollectionViewCell()
            
            return cell
        }
    }
    
    func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath, type: TypeUserCollectionType) {
        switch type {
        case .category:
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCategoryCollectionViewCell {
                cell.isSelected = true
                didSelectCategory(index: indexPath.row)
            }
        case .product:
            didSelectProduct(index: indexPath.row)
        }
    }
    
    func didSelectProduct(index: Int) {
        NavigationManager.instance.pushVC(to: .productDetail(item: listProduct?[index], delegate: self), presentation: .ModalNoNav(completion: {
        }))
    }
    
    func getTitleCategory(indexPath: IndexPath) -> String {
        switch indexPath.item {
        case 0:
            var item = ProductType()
            item.productTypeName = "ทั้งหมด"
            return item.productTypeName ?? ""
        default:
            guard let items = self.listCategory, items.count != 0 else { return "" }
            let item = items[indexPath.item - 1]
            return item.productTypeName ?? ""
        }
    }
    
    
    func editingSearch(_ search: String) {
        if search.isEmpty {
            self.searchText = nil
            self.getProduct()
        } else {
            self.searchText = search
        }
    }
    
}

extension HomeViewModel: ProductDetailViewModelDelegate {
    func didUpdateOrderCart() {
        didUpdateCartBadge?()
    }
    
    
}

enum TypeUserCollectionType {
    case category
    case product
}
