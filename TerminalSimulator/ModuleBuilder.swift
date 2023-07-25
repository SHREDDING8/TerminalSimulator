//
//  ModuleBuilder.swift
//  TerminalSimulator
//
//  Created by SHREDDING on 25.07.2023.
//

import Foundation
import UIKit

protocol ModuleBuilderProtocol {
    
    static func createTerminalViewController()->UIViewController
    
}

class ModuleBuilder:ModuleBuilderProtocol{
    static func createTerminalViewController() -> UIViewController {
        let terminal = Terminal()
        let terminalView = TerminalViewController()
        let terminalPresenter = TerminalPresenter(view: terminalView, terminal: terminal)
        terminalView.presenter = terminalPresenter
        return terminalView
        
    }
    
}
