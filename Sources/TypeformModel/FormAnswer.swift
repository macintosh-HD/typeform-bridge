//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import FluentUtils
import Fluent
import Vapor

public final class FormAnswer: FluentModel {
    public static let schema = "form_answers"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Enum(key: .type)
    public var type: AnswerType
    
    @OptionalField(key: .text)
    public var text: String?
    
    @Children(for: \.$answer)
    public var choices: [ChoiceAnswer]
    
    @OptionalField(key: .email)
    public var email: String?
    
    @OptionalField(key: .date)
    public var date: Date?
    
    @OptionalField(key: .boolean)
    public var boolean: Bool?
    
    @OptionalField(key: .url)
    public var url: String?
    
    @OptionalField(key: .number)
    public var number: Double?
    
    @OptionalField(key: .fileUrl)
    public var fileUrl: String?
    
    @OptionalChild(for: \.$answer)
    public var payment: PaymentAnswer?
    
    @OptionalChild(for: \.$answer)
    public var field: FormField?
    
    @Parent(key: .response)
    public var response: FormResponse
    
    public init() {}
    
    public init(id: UUID? = nil, type: AnswerType, text: String? = nil, email: String?, date: Date? = nil, boolean: Bool? = nil, url: String? = nil, number: Double? = nil, fileUrl: String? = nil) {
        self.id = id
        self.type = type
        self.text = text
        self.email = email
        self.date = date
        self.boolean = boolean
        self.url = url
        self.number = number
        self.fileUrl = fileUrl
    }
}

extension FormAnswer {
    public enum FieldKeys: String, FluentFieldKeys {
        case type
        case text
        case email
        case date
        case boolean
        case url
        case number
        case fileUrl
        case response = "response_id"
    }
    
    public struct Public: Content {
        public var type: AnswerType
        public var text: String?
        public var choice: ChoiceAnswer.Public?
        public var email: String?
        public var date: Date?
        public var boolean: Bool?
        public var url: String?
        public var number: Double?
        public var fileUrl: String?
        public var payment: PaymentAnswer.Public?
        public var field: FormField.Public
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            
            self.type = try values.decode(AnswerType.self, forKey: .type)
            self.text = try values.decodeIfPresent(String.self, forKey: .text)
            self.choice = try values.decodeIfPresent(ChoiceAnswer.Public.self, forKey: .choice)
            self.email = try values.decodeIfPresent(String.self, forKey: .email)
            if let rawDate = try values.decodeIfPresent(String.self, forKey: .date) {
                self.date = dateFormatter.date(from: rawDate)
            }
            self.boolean = try values.decodeIfPresent(Bool.self, forKey: .boolean)
            self.url = try values.decodeIfPresent(String.self, forKey: .url)
            self.number = try values.decodeIfPresent(Double.self, forKey: .number)
            self.fileUrl = try values.decodeIfPresent(String.self, forKey: .fileUrl)
            self.payment = try values.decodeIfPresent(PaymentAnswer.Public.self, forKey: .payment)
            self.field = try values.decode(FormField.Public.self, forKey: .field)
        }
    }
    
    public convenience init(_ object: Public) {
        self.init(
            type: object.type,
            text: object.text,
            email: object.email,
            date: object.date,
            boolean: object.boolean,
            url: object.url,
            number: object.number,
            fileUrl: object.fileUrl
        )
    }
}
