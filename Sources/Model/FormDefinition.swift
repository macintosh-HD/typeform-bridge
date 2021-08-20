//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Fluent
import Vapor

public final class FormDefinition: FluentModel {
    public static let schema = "form_definitions"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .definitionId)
    public var definitionId: String
    
    @Field(key: .title)
    public var title: String
    
    @Children(for: \.$definition)
    public var fields: [FormField]
    
    @Parent(key: .response)
    public var response: FormResponse
    
    public init() {}
    
    public init(id: UUID? = nil, definitionId: String, title: String) {
        self.id = id
        self.definitionId = definitionId
        self.title = title
    }
}

extension FormDefinition {
    public enum FieldKeys: String, FluentFieldKeys {
        case definitionId = "definition_id"
        case title
        case response = "response_id"
    }
    
    public struct Public: Content {
        public var id: String
        public var title: String
        public var fields: [FormField.Public]
    }
    
    public convenience init(_ object: Public) {
        self.init(
            definitionId: object.id,
            title: object.title
        )
    }
}
