//
//  File.swift
//  
//
//  Created by Julian Gentges on 20.08.21.
//

import TypeformModel
import Fluent

public extension Database {
    func `enum`<E: FluentEnum>(_ `enum`: E.Type) -> EnumBuilder {
        self.enum(`enum`.name)
    }
}

public extension FluentEnum where RawValue == String {
    static func create(on database: Database) -> EventLoopFuture<DatabaseSchema.DataType> {
        allCases.reduce(database.enum(Self.self)) { $0.case($1.rawValue) }.create()
    }
    
    static func update(on database: Database) -> EventLoopFuture<DatabaseSchema.DataType> {
        allCases.reduce(database.enum(Self.self)) { $0.case($1.rawValue) }.update()
    }
    
    static func delete(from database: Database) -> EventLoopFuture<Void> {
        database.enum(Self.self).delete()
    }
}
