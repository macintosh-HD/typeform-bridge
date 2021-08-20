//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

protocol TypeformEndpoint {
    var app: Application { get }
}

enum TypeformError: Error {
    case noConfiguration
}

extension TypeformEndpoint {
    func send(_ method: HTTPMethod, to uri: URI, beforeSend: (inout ClientRequest) throws -> () = { _ in }) throws -> EventLoopFuture<ClientResponse> {
        guard let apiKey = app.typeformConfiguration?.apiKey else {
            throw TypeformError.noConfiguration
        }
        
        return app.client.send(method, to: uri) { req in
            try beforeSend(&req)
            
            let auth = BearerAuthorization(token: apiKey)
            req.headers.bearerAuthorization = auth
        }
    }
}
