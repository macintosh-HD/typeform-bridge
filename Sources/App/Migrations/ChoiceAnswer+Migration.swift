//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Model
import Fluent

extension ChoiceAnswer {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            ChoiceType.create(on: database)
                .flatMap { choiceType in
                    database.schema(schema)
                        .id()
                        .field(FieldKeys.type, choiceType)
                        .field(FieldKeys.value, .string)
                        .field(FieldKeys.answer, .uuid, .required, .references(FormAnswer.schema, .id))
                        .create()
                }
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete().flatMap {
                ChoiceType.delete(from: database)
            }
        }
    }
}
