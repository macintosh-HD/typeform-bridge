//
//  File.swift
//  
//
//  Created by Julian Gentges on 19.08.21.
//

import Fluent
import Vapor

public final class FormVariable: FluentModel {
    public static let schema = "form_variables"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .key)
    public var key: String
    
    @Enum(key: .type)
    public var type: VariableType
    
    @OptionalField(key: .text)
    public var text: String?
    
    @OptionalField(key: .number)
    public var number: Int?
    
    @Parent(key: .response)
    public var response: FormResponse
    
    public init() {}
    
    public init(id: UUID? = nil, key: String, type: VariableType, text: String? = nil, number: Int? = nil) {
        self.id = id
        self.key = key
        self.type = type
        self.number = number
    }
}

extension FormVariable {
    public enum FieldKeys: String, FluentFieldKeys {
        case key
        case type
        case text
        case number
        case response = "response_id"
    }
    
    public struct Public: Content {
        public var key: String
        public var type: VariableType
        public var text: String?
        public var number: Int?
    }
    
    public convenience init(_ object: Public) {
        self.init(
            key: object.key,
            type: object.type,
            text: object.text,
            number: object.number
        )
    }
}
