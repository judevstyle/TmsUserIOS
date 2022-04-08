//
//  ProfileHistoryCollectionViewCellViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ProfileHistoryCollectionProtocolInput {
}

protocol ProfileHistoryCollectionProtocolOutput: class {
    var didGetInformationSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
}

protocol ProfileHistoryCollectionProtocol: ProfileHistoryCollectionProtocolInput, ProfileHistoryCollectionProtocolOutput {
    var input: ProfileHistoryCollectionProtocolInput { get }
    var output: ProfileHistoryCollectionProtocolOutput { get }
}

class ProfileHistoryCollectionViewModel: ProfileHistoryCollectionProtocol, ProfileHistoryCollectionProtocolOutput {
    var input: ProfileHistoryCollectionProtocolInput { return self }
    var output: ProfileHistoryCollectionProtocolOutput { return self }
    
    // MARK: - UseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
    ) {
    }
    
    // MARK - Data-binding OutPut
    var didGetInformationSuccess: (() -> Void)?
    
    func setViewController(vc: UIViewController?) {
        self.vc = vc
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return 3
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
//        cell.selectionStyle = .none
//        cell.item = listInformation?[indexPath.item]
        return UITableViewCell()
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 250
    }
}
