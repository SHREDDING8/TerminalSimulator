//
//  TerminalPresenter.swift
//  TerminalSimulator
//
//  Created by SHREDDING on 25.07.2023.
//

import Foundation

protocol TerminalViewProtocol: AnyObject {
    func showGreeting(greetingString:String)
    
}

protocol TerminalPresenterProtocol: AnyObject {
    
    var terminal:Terminal { get }
    
    init(view: TerminalViewProtocol, terminal: Terminal)
    
    func greeting()
    
}

class TerminalPresenter: TerminalPresenterProtocol{
    
    weak var view:TerminalViewProtocol?
    
    var terminal:Terminal
    
    
    required init(view: TerminalViewProtocol, terminal: Terminal) {
        self.view = view
        self.terminal = terminal
    }
    
    
    func greeting() {
        let greetingString = "Hello %username%! To see all comands write help"
        view?.showGreeting(greetingString: greetingString)
        
    }
    
    
}


