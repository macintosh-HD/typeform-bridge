//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import TypeformModel
import Fluent

extension FormResponse {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema)
                .id()
                .field(FieldKeys.formId, .string, .required)
                .field(FieldKeys.token, .string)
                .field(FieldKeys.submittedAt, .datetime)
                .field(FieldKeys.landedAt, .datetime)
                .field(FieldKeys.event, .uuid, .required, .references(FormEvent.schema, .id))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete()
        }
    }
}
