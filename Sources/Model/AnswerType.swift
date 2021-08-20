//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import Vapor

public enum AnswerType: String, CaseIterable, FluentEnum, Content {
    public static let name = "answer_type"
    
    case text
    case choice
    case choices
    case email
    case url
    case date
    case boolean
    case number
    case fileUrl = "file_url"
    case payment
}
