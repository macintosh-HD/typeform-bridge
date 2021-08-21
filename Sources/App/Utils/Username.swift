//
//  File.swift
//  
//
//  Created by Julian Gentges on 21.08.21.
//

import Vapor

enum Username {
    enum Error: LocalizedError {
        case runError(Swift.Error)
        case commandError(String)
        case noOutput
        
        var errorDescription: String {
            var description = "Could not automatically determine the current users username.\n"
            switch self {
            case let .runError(error):
                description = description + error.localizedDescription
            case let .commandError(error):
                description = description + error
            case .noOutput:
                description = description + "No name returned!"
            }
            return description
        }
    }
    
    static func get() throws -> String {
        let process = Process()
        process.launchPath = "id"
        process.arguments = ["-un"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
        } catch {
            throw Error.runError(error)
        }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        if let error = String(data: errorData, encoding: .utf8) {
            throw Error.commandError(error)
        }
        guard let output = String(data: outputData, encoding: .utf8) else {
            throw Error.noOutput
        }
        
        return output
    }
}
