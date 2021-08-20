//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Fluent
import Vapor

public final class ChoiceAnswer: FluentModel {
    public static let schema = "choice_answers"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Enum(key: .type)
    public var type: ChoiceType
    
    @Field(key: .value)
    public var value: String
    
    @Parent(key: .answer)
    public var answer: FormAnswer
    
    public init() {}
    
    public init(id: UUID? = nil, type: ChoiceType, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
}

extension ChoiceAnswer {
    public enum FieldKeys: String, FluentFieldKeys {
        case type
        case value
        case answer
    }
    
    public enum ChoiceType: String, CaseIterable, FluentEnum, Content {
        public static let name = "choice_type"
        
        case label
        case labels
        case other
    }
    
    public struct Public: Content {
        public var label: String?
        public var labels: [String]?
        public var other: String?
        
        public func convert() -> [ChoiceAnswer] {
            var result = [ChoiceAnswer]()
            
            if let label = label {
                let choiceAnswer = ChoiceAnswer(type: .label, value: label)
                result.append(choiceAnswer)
            } else if let labels = labels {
                let choiceAnswers = labels.map { ChoiceAnswer(type: .labels, value: $0) }
                result.append(contentsOf: choiceAnswers)
            }
            
            if let other = other {
                let choiceAnswer = ChoiceAnswer(type: .other, value: other)
                result.append(choiceAnswer)
            }
            
            return result
        }
    }
}

extension Array where Element == ChoiceAnswer {
    public func convert() -> ChoiceAnswer.Public {
        let label = first { $0.type == .label }?.value
        let labels = reduce([String]()) { $1.type == .labels ? $0 + [$1.value] : $0 }
        let other = first { $0.type == .other }?.value
        
        return ChoiceAnswer.Public(
            label: label,
            labels: labels.isEmpty ? nil : labels,
            other: other
        )
    }
}
