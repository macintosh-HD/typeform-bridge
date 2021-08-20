//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Model
import Fluent

extension FormAnswer {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            AnswerType.create(on: database)
                .flatMap { answerType in
                    database.schema(schema)
                        .id()
                        .field(FieldKeys.type, answerType)
                        .field(FieldKeys.text, .string)
                        .field(FieldKeys.email, .string)
                        .field(FieldKeys.date, .date)
                        .field(FieldKeys.boolean, .bool)
                        .field(FieldKeys.url, .string)
                        .field(FieldKeys.number, .double)
                        .field(FieldKeys.fileUrl, .string)
                        .field(FieldKeys.response, .uuid, .required, .references(FormResponse.schema, .id))
                        .create()
                }
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(schema).delete().flatMap {
                AnswerType.delete(from: database)
            }
        }
    }
}
