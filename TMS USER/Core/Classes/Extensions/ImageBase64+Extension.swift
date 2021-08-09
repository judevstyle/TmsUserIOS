//
//  ImageBase64+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 29/6/2564 BE.
//

import Foundation
import UIKit

extension String {
    func convertBase64StringToImage() -> UIImage {
        let imageData = Data.init(base64Encoded: self, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
}


extension UIImage {
    func convertImageToBase64String(quality: CGFloat) -> String {
        return self.jpegData(compressionQuality: quality)?.base64EncodedString() ?? ""
    }
}
