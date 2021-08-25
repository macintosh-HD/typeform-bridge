//
//  File.swift
//  
//
//  Created by Julian Gentges on 20.08.21.
//

import TypeformModel
import Fluent

public extension SchemaBuilder {
    func field<K: FluentFieldKeys>(
        _ key: K,
        _ dataType: DatabaseSchema.DataType,
        _ constraints: DatabaseSchema.FieldConstraint...
    ) -> Self {
        self.field(.definition(
            name: .key(key.key),
            dataType: dataType,
            constraints: constraints
        ))
    }
    
    func unique<K: FluentFieldKeys>(on fields: K..., name: String? = nil) -> Self {
        self.constraint(.constraint(.unique(fields: fields.map { .key($0.key) }), name: name))
    }
    
    func deleteUnique<K: FluentFieldKeys>(on fields: K...) -> Self {
        self.schema.deleteConstraints.append(.constraint(.unique(fields: fields.map { .key($0.key) })))
        return self
    }
    
    func foreignKey<K: FluentFieldKeys>(
        _ field: K,
        references foreignSchema: String,
        _ foreignField: FieldKey,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction,
        name: String? = nil
    ) -> Self {
        self.schema.createConstraints.append(.constraint(
            .foreignKey(
                [.key(field.key)],
                foreignSchema,
                [.key(foreignField)],
                onDelete: onDelete,
                onUpdate: onUpdate
            ),
            name: name
        ))
        return self
    }
    
    func foreignKey<K: FluentFieldKeys, O: FluentFieldKeys>(
        _ field: K,
        references foreignSchema: String,
        _ foreignField: O,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction,
        name: String? = nil
    ) -> Self {
        foreignKey(
            field,
            references: foreignSchema,
            foreignField.key,
            onDelete: onDelete,
            onUpdate: onUpdate,
            name: name
        )
    }
}
