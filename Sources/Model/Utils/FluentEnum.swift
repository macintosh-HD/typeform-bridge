//
//  File.swift
//  
//
//  Created by Julian Gentges on 20.08.21.
//

import Fluent

public protocol FluentEnum: RawRepresentable, CaseIterable {
    static var name: String { get }
}
