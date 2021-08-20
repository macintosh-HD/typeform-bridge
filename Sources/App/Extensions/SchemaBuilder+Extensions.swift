//
//  File.swift
//  
//
//  Created by Julian Gentges on 20.08.21.
//

import Model
import Fluent

public extension SchemaBuilder {
    func field<K: FluentFieldKeys>(
        _ key: K,
        _ dataType: DatabaseSchema.DataType,
        _ constraints: DatabaseSchema.FieldConstraint...
    ) -> Self {
        return self.field(key.key, dataType)
    }
}
