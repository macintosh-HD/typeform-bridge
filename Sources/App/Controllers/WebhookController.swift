//
//  WebhookController.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import TypeformModel
import PayloadValidation
import Vapor

struct WebhookController: RouteCollection {
    let app: Application
    let signatureHeaderName: String
    
    func boot(routes: RoutesBuilder) throws {
        var routes = routes
        if let secretToken = try Environment.secret(key: "TYPEFORM_SECRET_FILE", fileIO: app.fileio, on: app.eventLoopGroup.next()).wait() {
            let validation = PayloadValidationMiddleware(secretToken: secretToken, signatureHeaderName: signatureHeaderName)
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
                        if let score = payload.formResponse.calculated {
                            let formScore = FormScore(score)
                            return response.$calculated.create(formScore, on: database).map { response }
                        } else {
                            return database.eventLoop.future(response)
                        }
                    }.flatMap { response -> EventLoopFuture<FormResponse> in
                        if let variables = payload.formResponse.variables {
                            let formVariables = variables.map(FormVariable.init(_:))
                            
                            return response.$variables.create(formVariables, on: database).map { response }
                        } else {
                            return database.eventLoop.future(response)
                        }
                    }.flatMap { response -> EventLoopFuture<FormResponse> in
                        if let definition = payload.formResponse.definition {
                            let formDefinition = FormDefinition(definition)
                            
                            return response.$definition.create(formDefinition, on: database).map { definition }
                            .flatMap { definition in
                                let fields = definition.fields.map(FormField.init(_:))
                                
                                return formDefinition.$fields.create(fields, on: database)
                            }
                            .map { response }
                        } else {
                            return database.eventLoop.future(response)
                        }
                    }.flatMap { response in
                        if let answers = payload.formResponse.answers {
                            return answers.map { answer in
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
                        } else {
                            return database.eventLoop.future()
                        }
                    }
            }
        }.transform(to: .ok)
    }
}
