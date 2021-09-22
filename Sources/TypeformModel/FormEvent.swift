//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import FluentUtils
import Fluent
import Vapor

public final class FormEvent: FluentModel {
    public static let schema = "form_events"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .eventId)
    public var eventId: String
    
    @Field(key: .type)
    public var type: String
    
    @OptionalChild(for: \.$event)
    public var response: FormResponse?
    
    public init() {}
    
    public init(id: UUID? = nil, eventId: String, type: String) {
        self.id = id
        self.eventId = eventId
        self.type = type
    }
}

extension FormEvent {
    public enum FieldKeys: String, FluentFieldKeys {
        case eventId = "event_id"
        case type = "event_type"
    }
    
    public struct Public: Content {
        public var id: UUID?
        public var eventId: String
        public var eventType: String
        public var formResponse: FormResponse.Public
    }
    
    public convenience init(_ object: Public) {
        self.init(
            eventId: object.eventId,
            type: object.eventType
        )
    }
}
