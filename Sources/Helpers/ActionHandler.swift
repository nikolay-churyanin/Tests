//
//  ActionHandler.swift
//  Test3
//
//  Created by Nikolay Churyanin on 22.05.2020.
//

import Services
import Foundation

extension ActionHandler {

    public enum ActionType {

        case close
        case message(String)
    }
}

public enum ActionHandler {

    public static func handle(command: String, completion: @escaping (ActionType)->Void) {

        switch command.lowercased() {
        case "-close":
            completion(.close)
            break
        case "-help":
            completion(.message("\nEnter \"-close\" to exit\n"))
        case let name:

            RepositoriesService.loadRepositories(name: name) { result in
                switch result {
                case let .success(repositories):
                    completion(.message(
                        repositories.reduce("\n" + name + "'s repositories:\n") {
                            $0 + "   " + $1 + "\n"
                        }
                    ))
                case let .failure(message):
                    completion(.message(message))
                }

                CFRunLoopStop(CFRunLoopGetCurrent())
            }

            CFRunLoopRun()
        }
    }
}
