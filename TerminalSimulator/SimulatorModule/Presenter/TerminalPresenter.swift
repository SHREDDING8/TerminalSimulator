//
//  TerminalPresenter.swift
//  TerminalSimulator
//
//  Created by SHREDDING on 25.07.2023.
//

import Foundation

protocol TerminalViewProtocol: AnyObject {
    func showGreeting(greetingString:String)
    func setTextViewText(text:String)
    func appendTextViewText(text:String)
    
    func showColorPicker()
    
}

protocol TerminalPresenterProtocol: AnyObject {
    
    var terminal:Terminal { get }
    
    init(view: TerminalViewProtocol, terminal: Terminal)
    
    func greeting()
    
    func textViewDidChange(text:String)
    func updateFullText(text:String)
    
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
    
    
    func textViewDidChange(text:String) {
        
        if self.terminal.allText.count > text.count{
            if self.terminal.currentUserText == ""{
                view?.setTextViewText(text: self.terminal.allText)
            }
            return
        }
        
        self.terminal.currentUserText = text.replacingOccurrences(of:  self.terminal.allText, with: "")
        
        if self.terminal.currentUserText == text{
            view?.setTextViewText(text: self.terminal.allText)
            self.terminal.currentUserText = ""
            return
        }
        
        
        if self.terminal.currentUserText.hasSuffix("\n"){
            
            self.terminal.currentUserText = self.terminal.currentUserText.replacingOccurrences(of: "\n", with: "")
            
            let response = self.terminal.getCommand()
            
            if !response.isEmpty{
                
                if response == "CLEAR"{
                    view?.setTextViewText(text: "")
                }else{
                    view?.appendTextViewText(text: response + "\n")
                }
                
                if self.terminal.terminalState == .backgroundColor ||
                    self.terminal.terminalState == .textColor {
                    view?.showColorPicker()
                }
                
            }
            view?.appendTextViewText(text:  self.terminal.startRawText)
                        
            self.terminal.currentUserText = ""
        }
        
    }
    
    func updateFullText(text:String){
        self.terminal.allText = text
    }
    
}


