//
//  TerminalViewController.swift
//  TerminalSimulator
//
//  Created by SHREDDING on 25.07.2023.
//

import UIKit

class TerminalViewController: UIViewController {
    
    var presenter:TerminalPresenterProtocol!
    
    @IBOutlet weak var fieldView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    
    var colorPicker:UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        return picker
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.greeting()
        
        self.colorPicker.delegate = self
        
        self.textView.addLeftRightToolBar(onLeft: (target: self, action: #selector(tapGetPrevCommand)), onRight: (target: self, action: #selector(tapGetNextCommand)))
        
        self.addKeyboardObservers()

    }
    
}

// MARK: - Keyboard

extension TerminalViewController{
    
    fileprivate func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification){
        if let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            textViewBottomConstraint.constant = keyboard.height + 10
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            textViewBottomConstraint.constant = 0
        }
    }
    
}

// MARK: - UIColorPickerViewControllerDelegate

extension TerminalViewController:UIColorPickerViewControllerDelegate{
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
        if presenter.terminal.terminalState == .backgroundColor{
            self.view.backgroundColor = color
            self.fieldView.backgroundColor = color
            self.textView.backgroundColor = color
        }else if presenter.terminal.terminalState == .textColor{
            self.textView.textColor = color
        }
        
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        presenter.terminal.terminalState = .none
    }
}

// MARK: - UiTextView Delegate

extension TerminalViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        
        if presenter.terminal.allText.count > self.textView.text.count{
            if presenter.terminal.currentUserText == ""{
                self.textView.text = presenter.terminal.allText
            }
        }else{
            presenter.terminal.currentUserText = self.textView.text.replacingOccurrences(of:  presenter.terminal.allText, with: "")
            
            
            if presenter.terminal.currentUserText == self.textView.text{
                self.textView.text = presenter.terminal.allText
                presenter.terminal.currentUserText = ""
                return
            }
            
            
            if presenter.terminal.currentUserText.hasSuffix("\n"){
                presenter.terminal.currentUserText = presenter.terminal.currentUserText.replacingOccurrences(of: "\n", with: "")
                let response = presenter.terminal.getCommand()
                if !response.isEmpty{
                    if response == "CLEAR"{
                        self.textView.text = ""
                    }else{
                        self.textView.text += response + "\n"
                    }
                    
                    if presenter.terminal.terminalState == .backgroundColor ||
                        presenter.terminal.terminalState == .textColor {
                        self.present(self.colorPicker, animated: true)
                    }
                }
                self.textView.text += presenter.terminal.startRawText
                presenter.terminal.allText = self.textView.text
                presenter.terminal.currentUserText = ""
            }
            
            
        }
        
    }
    
    
    @objc func tapGetPrevCommand(){
        if presenter.terminal.history.count > 1{
            let index = self.textView.text.index(self.textView.text.endIndex, offsetBy: -presenter.terminal.currentUserText.count)
            
            self.textView.text = String(self.textView.text[self.textView.text.startIndex..<index])
            
            self.textView.text += presenter.terminal.getPrevCommand()
        }
    }
    
    @objc func tapGetNextCommand(){
        let index = self.textView.text.index(self.textView.text.endIndex, offsetBy: -presenter.terminal.currentUserText.count)
        
        self.textView.text = String(self.textView.text[self.textView.text.startIndex..<index])
        
        self.textView.text += presenter.terminal.getNextCommand()
    }
    
    
}



extension TerminalViewController:TerminalViewProtocol{
    func showGreeting(greetingString: String) {
        
        let greetingList = greetingString.split(separator: "")
        
        self.textView.text = presenter.terminal.startRawText
        
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.textView.text += greetingList[index]
            if index == greetingList.count - 1{
                timer.invalidate()
                self.textView.isEditable = true
                self.textView.becomeFirstResponder()
                self.textView.text +=  "\n" + self.presenter.terminal.startRawText
                self.presenter.terminal.allText = self.textView.text
            }
            
            index += 1
        }
        
    }
    
    
}
