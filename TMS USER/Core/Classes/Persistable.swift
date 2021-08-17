//
//  Persistable.swift
//  KETO_iOS_App
//
//  Created by Nontawat Kanboon on 22/7/2563 BE.
//  Copyright © 2563 ketoapp. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
