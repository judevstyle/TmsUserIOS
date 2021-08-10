//
//  AlertCustomViewswift.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/17/21.
//

import Foundation
import UIKit

extension UIViewController {
    //Show a basic alert
    func showAlertComfirm(titleText : String?, messageText : String?, dismissAction: @escaping () -> Void, confirmAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: titleText ?? "", message: messageText ?? "", preferredStyle: .alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        // Change Title With Color and Font:
        
        let myTitle = titleText ?? ""
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myTitle as String, attributes: [NSAttributedString.Key.font:UIFont.PrimaryText(size: 18), NSAttributedString.Key.foregroundColor: UIColor.black])
        alertController.setValue(myMutableString, forKey: "attributedTitle")
        
        // Change Message With Color and Font
        
        let myMessage  = messageText ?? ""
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: myMessage as String, attributes: [NSAttributedString.Key.font:UIFont.PrimaryText(size: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        
        // Action Cancal
        let actionCancal = UIAlertAction(title: "ยกเลิก", style: .default, handler: { _ in
            dismissAction()
        })
        actionCancal.setValue(UIColor.Primary, forKey: "titleTextColor")
        alertController.addAction(actionCancal)
        
        // Action. OK
        let actionConfirm = UIAlertAction(title: "ยืนยัน", style: .default, handler: { _ in
            confirmAction()
        })
        actionConfirm.setValue(UIColor.Primary, forKey: "titleTextColor")
        alertController.addAction(actionConfirm)
        alertController.view.sizeToFit()
        self.present(alertController, animated: true, completion: nil)
    }
}


