//
//  SplashViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLoding()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.stopLoding()
            NavigationManager.instance.setRootViewController(rootView: .intro, isTranslucent: true)
        }
        
    }
}
