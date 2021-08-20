//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Fluent
import Vapor

public final class FormField: FluentModel {
    public static let schema = "form_fields"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: .fieldId)
    public var fieldId: String
    
    @OptionalField(key: .title)
    public var title: String?
    
    @Enum(key: .type)
    public var type: QuestionType
    
    @OptionalField(key: .ref)
    public var ref: String?
    
    @OptionalField(key: .allowsMultiple)
    public var allowMultipleSelections: Bool?
    
    @OptionalField(key: .allowOther)
    public var allowOtherChoice: Bool?
    
    @OptionalParent(key: .answer)
    public var answer: FormAnswer?
    
    @OptionalParent(key: .definition)
    public var definition: FormDefinition?
    
    public init() {}
    
    public init(id: UUID? = nil, fieldId: String, title: String? = nil, type: QuestionType, ref: String? = nil, allowMultipleSelections: Bool? = nil, allowOtherChoice: Bool? = nil) {
        self.id = id
        self.fieldId = fieldId
        self.title = title
        self.type = type
        self.ref = ref
        self.allowMultipleSelections = allowMultipleSelections
        self.allowOtherChoice = allowOtherChoice
    }
}

extension FormField {
    public enum FieldKeys: String, FluentFieldKeys {
        case fieldId = "field_id"
        case title
        case type
        case ref
        case allowsMultiple = "allows_multiple_selections"
        case allowOther = "allow_other_choice"
        case answer = "answer_id"
        case definition = "definition_id"
    }
    
    public struct Public: Content {
        public var id: String
        public var title: String?
        public var type: QuestionType
        public var ref: String?
        public var allowMultipleSelections: Bool?
        public var allowOtherChoice: Bool?
    }
    
    public convenience init(_ object: Public) {
        self.init(
            fieldId: object.id,
            title: object.title,
            type: object.type,
            ref: object.ref,
            allowMultipleSelections: object.allowMultipleSelections,
            allowOtherChoice: object.allowOtherChoice
        )
    }
}
