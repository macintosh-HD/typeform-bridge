//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Fluent
import Vapor

public final class PaymentAnswer: FluentModel {
    public static let schema = "payment_answers"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .amount)
    public var amount: String
    
    @Field(key: .last4)
    public var last4: String
    
    @Field(key: .name)
    public var name: String
    
    @Field(key: .success)
    public var success: Bool
    
    @Parent(key: .answer)
    public var answer: FormAnswer
    
    public init() {}
    
    public init(id: UUID? = nil, amount: String, last4: String, name: String, success: Bool) {
        self.id = id
        self.amount = amount
        self.last4 = last4
        self.name = name
        self.success = success
    }
}

extension PaymentAnswer {
    public enum FieldKeys: String, FluentFieldKeys {
        case amount
        case last4
        case name
        case success
        case answer = "answer_id"
    }
    
    public struct Public: Content {
        public var amount: String
        public var last4: String
        public var name: String
        public var success: Bool
    }
    
    public convenience init(_ object: Public) {
        self.init(
            amount: object.amount,
            last4: object.last4,
            name: object.name,
            success: object.success
        )
    }
}
