//
//  Optional+OptionalType.swift
//  QRCodeReader
//
//  Created by Vsevolod Onishchenko on 15.10.2018.
//  Copyright © 2018 OneActionApp. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
    
    @discardableResult
    func then(_ closure: (Wrapped) -> Void) -> Optional {
        if case .some(let item) = self {
            closure(item)
        }
        
        return self
    }

    func otherwise(_ closure: () -> Void) {
        if case .none = self {
            closure()
        }
    }
}
