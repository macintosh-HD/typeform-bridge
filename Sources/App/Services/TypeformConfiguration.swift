//
//  File.swift
//  
//
//  Created by Julian Gentges on 17.08.21.
//

import Vapor

struct TypeformConfiguration {
    var apiKey: String
}

private struct TypeformConfigurationKey: StorageKey {
    typealias Value = TypeformConfiguration
}

extension Application {
    var typeformConfiguration: TypeformConfiguration? {
        get {
            self.storage[TypeformConfigurationKey.self]
        }
        set {
            self.storage[TypeformConfigurationKey.self] = newValue
        }
    }
}
