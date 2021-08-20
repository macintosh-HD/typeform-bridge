//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

extension Typeform {
    struct Webhooks: TypeformEndpoint {
        private let webhookUrl: (String, String?) -> String = { formId, tag in formUrl(formId) + "/webhooks" + (tag != nil ? "/\(tag!)" : "") }
        
        let app: Application
        
        func list(formId: String) throws -> EventLoopFuture<[WebhookResponse]> {
            try send(.GET, to: "\(webhookUrl(formId, nil))")
                .flatMapThrowing { response in
                    try response.content.decode([WebhookResponse].self)
                }
        }
        
        func fetch(formId: String, tag: String) throws -> EventLoopFuture<WebhookResponse> {
            try send(.GET, to: "\(webhookUrl(formId, tag))")
                .flatMapThrowing { response in
                    try response.content.decode(WebhookResponse.self)
                }
        }
        
        func update(formId: String, tag: String, requestBody: WebhookRequest) throws -> EventLoopFuture<WebhookResponse> {
            try send(.PUT, to: "\(webhookUrl(formId, tag))") { request in
                try request.content.encode(requestBody, as: .json)
            }.flatMapThrowing { response in
                try response.content.decode(WebhookResponse.self)
            }
        }
        
        func delete(formId: String, tag: String) throws -> EventLoopFuture<HTTPStatus> {
            try send(.DELETE, to: "\(webhookUrl(formId, tag))").map { $0.status }
        }
    }
}
