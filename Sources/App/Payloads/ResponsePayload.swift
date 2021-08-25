//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import TypeformModel
import Vapor

struct ResponsePayload: Content {
    var totalItems: Int
    var pageCount: Int
    var items: [Item]
}

extension ResponsePayload {
    struct Item: Content {
        var landingId: String
        var token: String
        var responseId: String?
        var landedAt: Date
        var submittedAt: Date
        var metadata: Metadata
        var hidden: [String: String]
        var definition: FormDefinition
        var answers: [FormAnswer]
        var variables: [FormVariable]
        var calculated: FormScore
    }
}

extension ResponsePayload.Item {
    struct Metadata: Content {
        var userAgent: String
        var platform: String?
        var referer: String?
        var networkId: String?
    }
}
