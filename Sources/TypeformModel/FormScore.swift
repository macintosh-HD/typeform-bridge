//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import FluentUtils
import Fluent
import Vapor

public final class FormScore: FluentModel {
    public static let schema = "form_scores"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .score)
    public var score: Int
    
    @Parent(key: .response)
    public var response: FormResponse
    
    public init() {}
    
    public init(id: UUID? = nil, score: Int) {
        self.id = id
        self.score = score
    }
}

extension FormScore {
    public enum FieldKeys: String, FluentFieldKeys {
        case score
        case response = "response_id"
    }
    
    public struct Public: Content {
        public var score: Int
    }
    
    public convenience init(_ object: Public) {
        self.init(score: object.score)
    }
}
