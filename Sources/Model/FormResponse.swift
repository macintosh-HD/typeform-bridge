//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Fluent
import Vapor

public final class FormResponse: FluentModel {
    public static let schema = "form_responses"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .formId)
    public var formId: String
    
    @Field(key: .token)
    public var token: String
    
    @Field(key: .submittedAt)
    public var submittedAt: Date
    
    @Field(key: .landedAt)
    public var landedAt: Date
    
    @OptionalChild(for: \.$response)
    public var calculated: FormScore?
    
    @Children(for: \.$response)
    public var variables: [FormVariable]
    
    @OptionalChild(for: \.$response)
    public var definition: FormDefinition?
    
    @Children(for: \.$response)
    public var answers: [FormAnswer]
    
    @Parent(key: .event)
    public var event: FormEvent
    
    public init() {}
    
    public init(id: UUID? = nil, formId: String, token: String, submittedAt: Date, landedAt: Date) {
        self.id = id
        self.formId = formId
        self.token = token
        self.submittedAt = submittedAt
        self.landedAt = landedAt
    }
}

extension FormResponse {
    public enum FieldKeys: String, FluentFieldKeys {
        case formId = "form_id"
        case token
        case submittedAt = "submitted_at"
        case landedAt = "landed_at"
        case event = "event_id"
    }
    
    public struct Public: Content {
        public var formId: String
        public var token: String
        public var submittedAt: Date
        public var landedAt: Date
        public var calculated: FormScore.Public
        public var variables: [FormVariable.Public]
        public var definition: FormDefinition.Public
        public var answers: [FormAnswer.Public]
    }
    
    public convenience init(_ object: Public) {
        self.init(
            formId: object.formId,
            token: object.token,
            submittedAt: object.submittedAt,
            landedAt: object.landedAt
        )
    }
}
