//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

extension Typeform {
    struct Responses: TypeformEndpoint {
        private let responseUrl: (String) -> String = { formId in formUrl(formId) + "/responses" }
        
        let app: Application
        
        func fetch(formId: String, query: Query) throws -> EventLoopFuture<ResponsePayload> {
            try send(.GET, to: "\(responseUrl(formId))") { request in
                try request.query.encode(query)
            }.flatMapThrowing { response in
                try response.content.decode(ResponsePayload.self)
            }
        }
    }
}

extension Typeform.Responses {
    struct Query: Content {
        let pageSize: Int?
        let since: Date?
        let until: Date?
        let after: String?
        let before: String?
        let includedResponseIds: String?
        let excludedResponseIds: String?
        let completed: Bool?
        let sort: String?
        let query: String?
        let fields: [String]?
        let answeredFields: [String]?
    }
}
