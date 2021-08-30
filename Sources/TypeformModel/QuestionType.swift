//
//  File.swift
//  
//
//  Created by Julian Gentges on 18.08.21.
//

import FluentUtils
import Vapor

public enum QuestionType: String, CaseIterable, FluentEnum, Content {
    public static let name = "question_type"
    
    case shortText = "short_text"
    case longText = "long_text"
    case dropdown
    case multipleChoice = "multiple_choice"
    case pictureChoice = "picture_choice"
    case email
    case website
    case fileUpload = "file_upload"
    case date
    case legal
    case yesNo = "yes_no"
    case rating
    case opinionScale = "opinion_scale"
    case number
    case payment
}
