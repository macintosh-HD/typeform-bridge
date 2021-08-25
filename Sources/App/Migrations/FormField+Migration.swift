//
//  File 2.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import TypeformModel
import Fluent

extension FormField {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            QuestionType.create(on: database)
                .flatMap { questionType in
                    database.schema(schema)
                        .id()
                        .field(FieldKeys.fieldId, .string)
                        .field(FieldKeys.title, .string)
                        .field(FieldKeys.type, questionType)
                        .field(FieldKeys.ref, .string)
                        .field(FieldKeys.allowsMultiple, .bool)
                        .field(FieldKeys.allowOther, .bool)
                        .field(FieldKeys.answer, .uuid, .references(FormAnswer.schema, .id))
                        .field(FieldKeys.definition, .uuid, .references(FormDefinition.schema, .id))
                        .create()
                }
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete().flatMap {
                QuestionType.delete(from: database)
            }
        }
    }
}
