//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

struct WebhookRequest: Content {
    var url: URL
    var enabled: Bool
    var secret: String?
    var verifySSL: Bool?
}
