//
//  File.swift
//  
//
//  Created by Julian Gentges on 19.08.21.
//

import Model
import Fluent

extension FormVariable {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            VariableType.create(on: database)
                .flatMap { variableType in
                    database.schema(schema)
                        .id()
                        .field(FieldKeys.key, .string, .required)
                        .field(FieldKeys.type, variableType, .required)
                        .field(FieldKeys.text, .string)
                        .field(FieldKeys.number, .int)
                        .field(FieldKeys.response, .uuid, .required, .references(FormResponse.schema, .id))
                        .create()
                }
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete().flatMap {
                VariableType.delete(from: database)
            }
        }
    }
}
