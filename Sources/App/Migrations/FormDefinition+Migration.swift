//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import TypeformModel
import Fluent

extension FormDefinition {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema)
                .id()
                .field(FieldKeys.definitionId, .string)
                .field(FieldKeys.title, .string)
                .field(FieldKeys.response, .uuid, .required, .references(FormResponse.schema, .id))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete()
        }
    }
}
