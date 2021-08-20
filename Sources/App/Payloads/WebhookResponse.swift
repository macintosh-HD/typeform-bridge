//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

struct WebhookResponse: Content {
    var id: String
    var formId: String
    var tag: String
    var url: URL
    var enabled: Bool
    var secret: String?
    var verifySSL: Bool
    var createdAt: Date
    var updatedAt: Date
}
