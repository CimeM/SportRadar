//
//  ViewController.swift
//  SportRadar
//
//  Created by Martin Cimerman on 31/05/16.
//  Copyright © 2016 Martin Cimerman. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    
    var screenWidth             = CGFloat(0)
    var contentVerticalMargin = CGFloat(40)
    var courtFieldWidth         = CGFloat(0)
    var courtFieldHeight        = CGFloat(0)
    var courtX                  = CGFloat(0)
    var courtY                  = CGFloat(0)
    var courtFrame              = CGRect()
    
    var courtField              = ResortManager()
    
    var team1scoreInput         = UITextField()
    var team2scoreInput         = UITextField()
    var scoreLabel              = UILabel()
    let scoreboardButton        = UIButton()
    
    let buttonWidth = CGFloat(70)
    let buttonHeight = CGFloat(40)
    
    let tenisButton             = UIButton()
    let basketButton            = UIButton()
    let footbalButton           = UIButton()
    
    enum CourtType {
        case Tenis
        case Basketball
        case Football
        case notDefined
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap outside the text field to dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // positions visual elements relative to the screen width & height
        
        screenWidth = self.view.frame.width
        self.courtFieldWidth = screenWidth
        self.courtFieldHeight = (courtFieldWidth/2) // if height changes - field's ratio stays the same
        self.courtX = CGFloat(0)
        self.courtY = view.frame.height/2 - courtFieldHeight
        self.courtFrame = CGRect(x: CGFloat(courtX) , y: CGFloat(courtY), width: screenWidth, height: courtFieldHeight)
        
        self.showCourt(.Football)
        
        team1scoreInput.frame.origin.y =  courtY + courtFieldHeight + contentVerticalMargin
        team2scoreInput.frame.origin.y =  courtY + courtFieldHeight + contentVerticalMargin
        scoreboardButton.frame.origin.y =  contentVerticalMargin + team2scoreInput.frame.origin.y+team2scoreInput.frame.height
        
    }
    
    func footbalButtonAction(sender: UIButton!) {
        self.showCourt(.Football)
    }
    func basketButtonAction(sender: UIButton!) {
        self.showCourt(.Basketball)
    }
    func tenisButtonAction(sender: UIButton!) {
        self.showCourt(.Tenis)
    }
    func animateScoreboardAction(sender: UIButton!) {
        courtField.setresultForHome(Int(team1scoreInput.text!)!)
        courtField.setresultForAway(Int(team2scoreInput.text!)!)
        self.courtField.scoreBoardAnimation()
    }
    
    
    func showCourt(courtType : CourtType){
    
        self.view.viewWithTag(2)?.removeFromSuperview()
        
        switch courtType {
        case .Basketball:
            self.courtField =  ResortManager(frame: courtFrame , courtType: .Basketball)
        case .Tenis:
            self.courtField =  ResortManager(frame: courtFrame , courtType: .Tenis)
        default:
            self.courtField =  ResortManager(frame: courtFrame , courtType: .Football)
        }
        
        self.courtField.backgroundColor = UIColor.lightGrayColor()
        self.courtField.tag = 2
        view.insertSubview(courtField, atIndex: 2)
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     
     Draws the custom visual elements: buttons, court field, input fields
     */
    func setup() {
        
        textFieldInitialization()
        
        //scoreboard button frame
        self.scoreboardButton.frame.origin.y = self.team2scoreInput.frame.origin.y + self.team2scoreInput.frame.height+contentVerticalMargin
        
        
        // court change buttons
        tenisButton.frame = CGRectMake(contentVerticalMargin/2, contentVerticalMargin, buttonWidth, buttonHeight)
        tenisButton.backgroundColor = UIColor.blueColor()
        tenisButton.setTitle("Tenis", forState: UIControlState.Normal)
        tenisButton.addTarget(self, action: #selector(tenisButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tenisButton)
        
        basketButton.frame = tenisButton.frame
        basketButton.frame.origin.x += (tenisButton.frame.width+contentVerticalMargin)
        basketButton.backgroundColor = UIColor.blueColor()
        basketButton.setTitle("Basket", forState: UIControlState.Normal)
        basketButton.addTarget(self, action: #selector(basketButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(basketButton)
        
        footbalButton.frame = basketButton.frame
        footbalButton.frame.origin.x += (basketButton.frame.width+contentVerticalMargin)
        footbalButton.backgroundColor = UIColor.blueColor()
        footbalButton.setTitle("Footbal", forState: UIControlState.Normal)
        footbalButton.addTarget(self, action: #selector(footbalButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(footbalButton)
        
        scoreboardButton.frame = CGRectMake(tenisButton.frame.origin.x+tenisButton.frame.width+contentVerticalMargin/2, contentVerticalMargin, buttonWidth, buttonHeight)
        scoreboardButton.backgroundColor = UIColor.darkGrayColor()
        scoreboardButton.setTitle("Button", forState: UIControlState.Normal)
        scoreboardButton.addTarget(self, action: #selector(animateScoreboardAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(scoreboardButton)
        
        
    }
    
    
    func textFieldInitialization () {
        
        team1scoreInput = UITextField(frame: CGRect(x: contentVerticalMargin,
            y: 0,
            width: self.buttonWidth,
            height: 40))
        team1scoreInput.borderStyle = UITextBorderStyle.Line
        team1scoreInput.autocapitalizationType = UITextAutocapitalizationType.Words
        team1scoreInput.text = "0"
        //team1scoreInput.delegate = self
        team1scoreInput.keyboardType = UIKeyboardType.NumberPad
        view.addSubview(team1scoreInput)
        
        team2scoreInput = UITextField(frame: CGRect(
            x: team1scoreInput.frame.origin.x+team1scoreInput.frame.width+contentVerticalMargin,
            y: 0,
            width: self.buttonWidth,
            height: team1scoreInput.frame.height))
        team2scoreInput.borderStyle = UITextBorderStyle.Line
        team2scoreInput.text = "0"
        //team2scoreInput.delegate = self
        team2scoreInput.keyboardType = UIKeyboardType.NumberPad
        view.addSubview(team2scoreInput)
        
        
        
        
        
    }
    
    // MARK: UITextFieldDelegate events and related methods
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String)
        -> Bool
    {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
            
            // Allow only digits in this field,
        // and limit its contents to a maximum of 3 characters.
        case team2scoreInput:
            return prospectiveText.containsOnlyCharactersIn("0123456789") &&
                prospectiveText.characters.count <= 3
            // Allow only digits in this field,
        // and limit its contents to a maximum of 3 characters.
        case team1scoreInput:
            return prospectiveText.containsOnlyCharactersIn("0123456789") &&
                prospectiveText.characters.count <= 3
            
                  // Do not put constraints on any other text field in this view
        // that uses this class as its delegate.
        default:
            return true
        }
        
    }
    
    // Dismiss the keyboard when the user taps the "Return" key or its equivalent
    // while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension String {
    
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
    
}
