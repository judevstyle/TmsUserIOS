//
//  UITextField+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 3/26/21.
//


import Foundation
import UIKit

extension UITextField {
    
    func setPaddingLeft(padding: CGFloat){
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 5))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    
    func setPaddingRight(padding: CGFloat){
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 5))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setTextFieldBottom() {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.size.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    func setPaddingLeftAndRight(padding: CGFloat){
        setPaddingLeft(padding: padding)
        setPaddingRight(padding: padding)
    }
    
}

//DatePicker
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector, dateStart: Date = Date(), isEnableMinDate: Bool = false) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        
        if isEnableMinDate == true  {
            var components = DateComponents()
            components.day = 1
            let minDate = Calendar.current.date(byAdding: components, to: dateStart)
            datePicker.minimumDate = minDate
        }
        
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
