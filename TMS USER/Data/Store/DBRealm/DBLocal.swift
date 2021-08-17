//
//  DBLocal.swift
//  KETO_iOS_App
//
//  Created by Nontawat Kanboon on 22/7/2563 BE.
//  Copyright © 2563 ketoapp. All rights reserved.
//

import Foundation
import RealmSwift

class ProductCartItems : Object {
    
    @objc private dynamic var structData:Data? = nil
    
    @objc dynamic var id: Int = -1
//    @objc public var productId: Int = -1

    override class func primaryKey() -> String? {
       return "id"
     }
    
    var productItems : ProductItems? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(ProductItems.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }

    public func incrementID() -> Int {
    let realm = try! Realm()
      return (realm.objects(ProductCartItems.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
