//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import TypeformModel
import Vapor

struct InsightSummary: Content {
    var form: FormInsights
    var fields: [FieldInsight]
}

extension InsightSummary {
    struct FormInsights: Content {
        var summary: Summary
        var platforms: [PlatformInsight]
    }
    
    struct FieldInsight: Content {
        var id: String
        var type: QuestionType
        var title: String
        var label: String?
        var ref: String
        var views: Int
        var dropoffs: Int
    }
}

extension InsightSummary.FormInsights {
    struct Summary: Content {
        var responseCount: Int
        var completionRate: Float
        var averageTime: TimeInterval
        var totalVisits: Int
        var uniqueVisits: Int
    }
    
    struct PlatformInsight: Content {
        var platform: Platform
        var responseCount: Int
        var completionRate: Float
        var averageTime: TimeInterval
        var totalVisits: Int
        var uniqueVisits: Int
    }
}

extension InsightSummary.FormInsights.PlatformInsight {
    enum Platform: String, Content {
        case desktop
        case tablet
        case phone
        case other
    }
}
