//
//  Bool+Extensions.swift
//  
//
//  Created by Julian Gentges on 22.09.21.
//

import Foundation

extension Bool: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = (value as NSString).boolValue
    }
}
