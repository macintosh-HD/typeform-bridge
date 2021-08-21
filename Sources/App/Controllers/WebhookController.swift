//
//  WebhookController.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Model
import Vapor

struct WebhookController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        var routes = routes
        if let secretToken = Environment.get("TYPEFORM_SECRET") {
            let validation = PayloadValidationMiddleware(secretToken: secretToken)
            routes = routes.grouped(validation)
        }
        
        let path: [PathComponent] = Environment.get("WEBHOOK_PATH")?
            .split(separator: "/")
            .map(String.init)
            .map(PathComponent.init(stringLiteral:)) ?? ["webhook"]
        let webhook = routes.grouped(path) 
        
        webhook.post(use: handle)
    }
    
    private func handle(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.content.decode(FormEvent.Public.self)
        
        return req.db.transaction { database -> EventLoopFuture<Void> in
            let formEvent = FormEvent(payload)
            
            return formEvent.create(on: database).map { formEvent }.flatMap { event in
                let formResponse = FormResponse(payload.formResponse)
                
                return event.$response.create(formResponse, on: database).map { formResponse }
                    .flatMap { response -> EventLoopFuture<FormResponse> in
                        let formScore = FormScore(payload.formResponse.calculated)
                        
                        return response.$calculated.create(formScore, on: database).map { response }
                    }.flatMap { response -> EventLoopFuture<FormResponse> in
                        let formVariables = payload.formResponse.variables.map(FormVariable.init(_:))
                        
                        return response.$variables.create(formVariables, on: database).map { response }
                    }.flatMap { response -> EventLoopFuture<FormResponse> in
                        let formDefinition = FormDefinition(payload.formResponse.definition)
                        
                        return response.$definition.create(formDefinition, on: database).map { formDefinition }
                            .flatMap { definition in
                                let fields = payload.formResponse.definition.fields.map(FormField.init(_:))
                                
                                return definition.$fields.create(fields, on: database)
                            }
                            .map { response }
                    }.flatMap { response in
                        payload.formResponse.answers.map { answer in
                            let formAnswer = FormAnswer(answer)
                            
                            return response.$answers.create(formAnswer, on: database)
                                .flatMap { _ -> EventLoopFuture<Void> in
                                    if let choice = answer.choice {
                                        let choiceAnswers = choice.convert()
                                        
                                        return formAnswer.$choices.create(choiceAnswers, on: database)
                                    }
                                    
                                    if let payment = answer.payment {
                                        let paymentAnswer = PaymentAnswer(payment)
                                        
                                        return formAnswer.$payment.create(paymentAnswer, on: database)
                                    }
                                    
                                    return database.eventLoop.future()
                                }
                                .flatMap {
                                    let formField = FormField(answer.field)
                                    
                                    return formAnswer.$field.create(formField, on: database)
                                }
                        }.flatten(on: database.eventLoop)
                    }
            }
        }.transform(to: .ok)
    }
}
