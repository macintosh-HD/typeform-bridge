//
//  File.swift
//  
//
//  Created by Julian Gentges on 20.08.21.
//

import Fluent

protocol FluentModel: Model {
    associatedtype FieldKeys: FluentFieldKeys
}

public protocol FluentFieldKeys: RawRepresentable where RawValue == String {}

public extension FluentFieldKeys {
    var key: FieldKey {
        FieldKey(stringLiteral: rawValue)
    }
}

extension FieldProperty where Model: FluentModel {
    convenience init(key: Model.FieldKeys) {
        self.init(key: key.key)
    }
}
extension OptionalFieldProperty where Model: FluentModel {
    convenience init(key: Model.FieldKeys) {
        self.init(key: key.key)
    }
}
extension EnumProperty where Model: FluentModel {
    convenience init(key: Model.FieldKeys) {
        self.init(key: key.key)
    }
}
extension ParentProperty where Model: FluentModel {
    convenience init(key: Model.FieldKeys) {
        self.init(key: key.key)
    }
}
extension OptionalParentProperty where Model: FluentModel {
    convenience init(key: Model.FieldKeys) {
        self.init(key: key.key)
    }
}
