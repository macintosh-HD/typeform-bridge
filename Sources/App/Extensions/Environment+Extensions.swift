//
//  Environment+Extensions.swift
//  
//
//  Created by Julian Gentges on 22.09.21.
//

import Vapor

extension Environment {
    static var migrating: Environment { .custom(name: "migrating") }
}
