//
//  OrderCartManager.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import Foundation
import RealmSwift

//public class OrderCartManager {
//
//    public static let shared: OrderCartManager = OrderCartManager()
//
//    fileprivate var productCartItem: [ProductItems] = []
//
//    public init() { }
//
//    public func getProductCart() -> [ProductItems] {
//        return []
//    }
//
//    public func setProductCart(items: [ProductItems]) {
//
//    }
//
//    public func clearProductCart() {
//    }
//}

struct OrderCartManager {
    
    static var sharedInstance = OrderCartManager()
    
    var realm: Realm!
    
    init() {
        self.realm = try! Realm()
    }
    
    func addProductCart(_ items: ProductItems, qty: Int, completion: @escaping () -> Void) {
        let productCartItems = ProductCartItems()
        productCartItems.id = productCartItems.incrementID()
        
        var productItems: ProductItems = items
        productItems.productCartId = productCartItems.id
        productItems.productCartQty = qty
        //set productItems
        productCartItems.productItems = productItems
        
        try! self.realm.write({ () -> Void in
            self.realm.add(productCartItems)
            completion()
        })
    }
    
    func getProductCart() -> [ProductItems?]? {
        do {
            let objs = self.realm.objects(ProductCartItems.self)
            
            var items: [ProductItems?] = []
            for item in objs {
                items.append(item.productItems)
            }
            return items
            
        } catch _ {
            return nil
        }
        return nil
    }
    
    func clearProductCart(completion: @escaping () -> Void) {
        do {
            let objs = self.realm.objects(ProductCartItems.self)
            
            for item in objs {
                try! self.realm.write {
                    self.realm.delete(item)
                }
            }
            completion()
        } catch _ {
        }
    }
    
    func updateProductCart(_ items: ProductItems, qty: Int, completion: @escaping () -> Void) {
//        let objs = self.realm.objects(ProductCartItems.self)

        do {
            let objs = self.realm.objects(ProductCartItems.self)
            
            if let item = objs.first(where: { $0.productItems?.productId == items.productId }) {
                
                let productCartItems = ProductCartItems()
                productCartItems.id = item.id
                
                var productItems: ProductItems = items
                productItems.productCartId = productCartItems.id
                productItems.productCartQty = qty
                
                //set productItems
                productCartItems.productItems = productItems

                try! realm.write {
                    realm.add(productCartItems, update: .modified)
                    completion()
                }
                
            } else {
                addProductCart(items, qty: qty, completion: {
                    completion()
                })
            }

        } catch _ {
        }
    }
    
    func removeItemProductCart(item: ProductItems?, completion: @escaping () -> Void) {
        do {
            let objs = self.realm.objects(ProductCartItems.self)
            if let itemProduct = item {
                for itemObj in objs {
                    if itemObj.productItems?.productId == itemProduct.productId {
                        try! self.realm.write {
                            self.realm.delete(itemObj)
                            completion()
                        }
                    }
                }
            }
        } catch _ {
        }
    }
    
}
