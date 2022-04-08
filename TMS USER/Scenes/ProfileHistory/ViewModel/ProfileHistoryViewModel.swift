//
//  ProfileHistoryViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ProfileHistoryProtocolInput {
}

protocol ProfileHistoryProtocolOutput: class {
    
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getNumberOfItemsInSection(_ collectionView: UICollectionView, section: Int) -> Int
}

protocol ProfileHistoryProtocol: ProfileHistoryProtocolInput, ProfileHistoryProtocolOutput {
    var input: ProfileHistoryProtocolInput { get }
    var output: ProfileHistoryProtocolOutput { get }
}

class ProfileHistoryViewModel: ProfileHistoryProtocol, ProfileHistoryProtocolOutput {
    var input: ProfileHistoryProtocolInput { return self }
    var output: ProfileHistoryProtocolOutput { return self }
    
    // MARK: - Properties
    private var vc: ProfileHistoryViewController
    
    init(
        vc: ProfileHistoryViewController
    ) {
        self.vc = vc
    }
    
    // MARK - Data-binding OutPut
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHistoryCollectionViewCell.identifier, for: indexPath) as! ProfileHistoryCollectionViewCell
        return cell
    }

    func getNumberOfItemsInSection(_ collectionView: UICollectionView, section: Int) -> Int {
        return 5
    }
}
