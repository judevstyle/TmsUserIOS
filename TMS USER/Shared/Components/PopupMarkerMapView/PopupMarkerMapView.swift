//
//  PopupMarkerMapView.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 5/22/21.
//

import UIKit

class PopupMarkerMapView: UIView {
    
    static let identifier = "PopupMarkerMapView"
    
    @IBOutlet weak var  OutletView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed(PopupMarkerMapView.identifier, owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
