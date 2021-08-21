//
//  File.swift
//  
//
//  Created by Julian Gentges on 21.08.21.
//

import Vapor

enum Username {
    static func get() -> String {
        let process = Process()
        process.launchPath = "id"
        process.arguments = ["-un"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        try process.run()
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(data: outputData, encoding: .utf8)
        let error = String(data: errorData, encoding: .utf8)
        
        if error != nil || output == nil {
            let error = error ?? "No return value."
            fatalError("Could not automatically determine the current users username.\n\(error)")
        }
        
        return output
    }
}
