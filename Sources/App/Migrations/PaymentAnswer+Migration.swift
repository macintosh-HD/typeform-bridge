//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Model
import Fluent

extension PaymentAnswer {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema)
                .id()
                .field(FieldKeys.amount, .string, .required)
                .field(FieldKeys.last4, .string, .required)
                .field(FieldKeys.name, .string, .required)
                .field(FieldKeys.success, .bool, .required)
                .field(FieldKeys.answer, .uuid, .required, .references(FormAnswer.schema, .id))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete()
        }
    }
}
