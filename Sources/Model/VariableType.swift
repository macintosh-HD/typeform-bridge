//
//  File.swift
//  
//
//  Created by Julian Gentges on 19.08.21.
//

import Vapor

public enum VariableType: String, CaseIterable, FluentEnum, Content {
    public static let name = "variable_type"
    
    case text
    case number
}
