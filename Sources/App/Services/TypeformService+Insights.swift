//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

extension Typeform {
    struct Insights: TypeformEndpoint {
        private let insightUrl: (String) -> String = { formId in baseUrl + "/insights/\(formId)" }
        
        let app: Application
        
        func summary(formId: String) throws -> EventLoopFuture<InsightSummary> {
            let summaryUrl = insightUrl(formId) + "/summary"
            
            return try send(.GET, to: "\(summaryUrl)").flatMapThrowing { response in
                try response.content.decode(InsightSummary.self)
            }
        }
    }
}
