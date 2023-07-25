//
//  Terminal.swift
//  Snake
//
//  Created by SHREDDING on 10.07.2023.
//

import Foundation
import UIKit

class Terminal{
    
    
    enum TerminalState {
        case backgroundColor
        case textColor
    }
    
    let allCommands:[String] = [
    "help",
    "username",
    "clear",
    "backgroundColor",
    "textColor"
    ]
    
    enum Commads:String {
        case help = "help"
        case username = "username"
        case clear = "clear"
        
        case changeBackgroundColor = "backgroundColor"
        
        case changeTextColor = "textColor"
        
        public func man()->String{
            switch self {
            case .help:
                return "Write help to get list of all commands"
            case .username:
                return "Write username <username> to set username into system"
            case .clear:
                return "This command clears terminal"
            case .changeBackgroundColor:
                return "Write this to change background Color"
            case .changeTextColor:
                return "Write this to change text Color"
            }
        }
        
    }
    
    
    
    var userName:String? = nil
    
    var cuurentFolder = "~"
    
    var device = UIDevice.current.name
    
    var startRawText:String{
        "\(userName ?? "username")@\(device) \(cuurentFolder) %    "
    }
    
    var currentUserText = ""
    
    var allText = ""
    
    
    var terminalState:TerminalState? = nil
    
    
    var history:[String] = [""]
    
    var historyCurrentIndex = 0
    
    
    public func getCommand()->String{
        let splittedUserText = self.currentUserText.split(separator: " ")
        if splittedUserText.count == 0{
            return ""
        }
        let command = Commads(rawValue: String(splittedUserText[0]))
        
        history.insert(String(splittedUserText[0]), at: history.count - 1)
        
        historyCurrentIndex = history.count - 1
        
        switch command {
        case .help:
            return getAllCommands()
            
        case .username:
            if splittedUserText.count != 2{
                return "Invalid arguments"
            }
            return self.setUsername(username: String(splittedUserText[1]))
            
        case .clear:
            return "CLEAR"
            
        case .changeBackgroundColor:
            terminalState = .backgroundColor
            return "change background color"
        
        case .changeTextColor:
            terminalState = .textColor
            return "change text color"
            
        case nil:
            return "Invalid command '\(splittedUserText[0])'"
            
        }
    }
    
    public func getAllCommands()->String{
        var response = "\n"
        for command in self.allCommands{
            response += "\(command) - " + Commads(rawValue: command)!.man() + "\n\n"
        }
        
        return response
    }
    
    public func setUsername(username:String)->String{
            self.userName = username
            return "Username setted - '\(username)'"
    }
    
    public func getPrevCommand()->String{
        self.historyCurrentIndex = self.historyCurrentIndex == 0 ? self.historyCurrentIndex : self.historyCurrentIndex - 1
        
        self.currentUserText = self.history[self.historyCurrentIndex]
        
        return self.currentUserText
    }
    
    public func getNextCommand()->String{
        self.historyCurrentIndex = self.historyCurrentIndex == self.history.count - 1 ? self.historyCurrentIndex : self.historyCurrentIndex + 1
        
        self.currentUserText = self.history[self.historyCurrentIndex]
        
        return self.currentUserText
    }
}
