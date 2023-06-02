//
//  Availability.swift
//  PullToRefreshKit
//
//  Created by Leo on 2017/11/9.
//  Copyright © 2017年 Leo Huang. All rights reserved.
//

import Foundation

public protocol SetUp {}
public extension SetUp where Self: AnyObject {
    @discardableResult
    @available(*, deprecated, message: "This method will be removed at V 1.0.0")
    func SetUp(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: SetUp {}


