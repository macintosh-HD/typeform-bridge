//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

struct Typeform {
    static let baseUrl = "https://api.typeform.com"
    static let formUrl: (String) -> String = { formId in baseUrl + "/forms/\(formId)" }
    
    let webhooks: Webhooks
    let responses: Responses
    let insights: Insights
    
    init(app: Application) {
        webhooks = .init(app: app)
        responses = .init(app: app)
        insights = .init(app: app)
    }
}

extension Application {
    var typeform: Typeform {
        .init(app: self)
    }
}
