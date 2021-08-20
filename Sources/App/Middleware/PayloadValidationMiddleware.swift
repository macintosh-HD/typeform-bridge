//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

struct PayloadValidationMiddleware: Middleware {
    
    let secretToken: SymmetricKey
    
    init(secretToken: String) {
        let data = Array(secretToken.utf8)
        self.secretToken = SymmetricKey(data: data)
    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let requestSignature = request.headers.first(name: .typeformSignature),
              let signatureData = Data(base64Encoded: requestSignature) else {
            request.logger.debug("No typeform signature header supplied.")
            return request.eventLoop.future(error: Abort(.badRequest))
        }
        
        return request.body.collect().unwrap(or: Abort(.noContent)).map { bytes -> Bool in
            let bodyData = Data(buffer: bytes)
            
            request.logger.debug("Request body not nil: \(String(data: bodyData, encoding: .utf8) != nil)")
            return verify(signature: signatureData, messageBody: bodyData)
        }
        .guard({ $0 }, else: Abort(.unauthorized))
        .flatMap { _ in next.respond(to: request) }
    }
    
    private func verify(signature: Data, messageBody: Data) -> Bool {
        return HMAC<SHA256>.isValidAuthenticationCode(signature, authenticating: messageBody, using: secretToken)
    }
}

extension HTTPHeaders.Name {
    public static let typeformSignature = HTTPHeaders.Name("HTTP_TYPEFORM_SIGNATURE")
}
