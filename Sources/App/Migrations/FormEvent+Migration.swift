//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Model
import Fluent

extension FormEvent {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema)
                .id()
                .field(FieldKeys.eventId, .string, .required)
                .field(FieldKeys.type, .string, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete()
        }
    }
}
