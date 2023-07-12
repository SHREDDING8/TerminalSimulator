//
//  ViewController.swift
//  Snake
//
//  Created by SHREDDING on 12.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let terminal = Terminal()
    
    // MARK: - Outlets
    
    @IBOutlet weak var fieldView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hello()
        
        self.addKeyboardObservers()
        
    }
    
    
    fileprivate func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification){
        if let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            textViewBottomConstraint.constant = keyboard.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            textViewBottomConstraint.constant = 0
        }
    }
    
    public func hello(){
        self.textView.text = terminal.startRawText
        let msg = "Hello %username%! To see all comands write help" .split(separator: "")
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.textView.text += msg[index]
            if index == msg.count - 1{
                timer.invalidate()
                self.textView.isEditable = true
                self.textView.becomeFirstResponder()
                self.textView.text +=  "\n" + self.terminal.startRawText
                self.terminal.allText = self.textView.text
            }
            
            index += 1
        }
    }
    
}



extension ViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
        if self.terminal.allText.count > self.textView.text.count{
            if self.terminal.currentUserText == ""{
                self.textView.text = self.terminal.allText
            }
        }else{
            self.terminal.currentUserText = self.textView.text.replacingOccurrences(of:  self.terminal.allText, with: "")
            
            
            if self.terminal.currentUserText == self.textView.text{
                self.textView.text = self.terminal.allText
                self.terminal.currentUserText = ""
                return
            }
            
            if self.terminal.currentUserText.hasSuffix("\n"){
                self.terminal.currentUserText = self.terminal.currentUserText.replacingOccurrences(of: "\n", with: "")
                let response = self.terminal.getCommand()
                if !response.isEmpty{
                    if response == "CLEAR"{
                        self.textView.text = ""
                    }else{
                        self.textView.text += response + "\n"
                    }
                    
                }
                self.textView.text += self.terminal.startRawText
                self.terminal.allText = self.textView.text
                self.terminal.currentUserText = ""
            }
        }
    }
    
}

