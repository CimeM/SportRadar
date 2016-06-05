//
//  ViewController.swift
//  SportRadar
//
//  Created by Martin Cimerman on 31/05/16.
//  Copyright © 2016 Martin Cimerman. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    
    var screenWidth = CGFloat(0)
    var contentVerticalMargin = CGFloat(40)
    var courtFieldWidth = CGFloat(0)//screen width
    var courtFieldHeight = CGFloat(0)
    var courtX = CGFloat(0)
    var courtY = CGFloat(0)
    var courtFrame = CGRect()
    
    var courtField = UIView()
    
    var scoreBoardItem = UIView()
    
    var gameManager = GameManager()
    
    var team1scoreInput = UITextField()
    var team2scoreInput = UITextField()
    var scoreLabel = UILabel()
    let scoreboardButton   = UIButton()
    
    enum CourtType {
        case Tenis
        case Basketball
        case Football
        case notDefined
    }
    
    func animateScoreboardAction(sender: UIButton!) {
        
        // save scores
        
        if team1scoreInput.text == nil {
            
            team1scoreInput.text = "\(gameManager.scoreTeam1)"
        }
        if team2scoreInput.text == nil {
            
            team2scoreInput.text = "\(gameManager.scoreTeam2)"
        }
        
        
        //TODO number imput only
        gameManager.setScore(Int(team1scoreInput.text!)!,
                             team2Score: Int(team2scoreInput.text!)!)
        
        
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        
        UIView.animateKeyframesWithDuration(5, delay: 0, options: options, animations: {
            
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/5, animations: {
                
                self.scoreBoardItem.frame.origin.x = self.view.frame.width/2-self.scoreBoardItem.frame.width/2
            })
            UIView.addKeyframeWithRelativeStartTime(2/5, relativeDuration: 1/5, animations: {
                
                
                self.scoreLabel.text = "\(self.gameManager.scoreTeam1):\(self.gameManager.scoreTeam2)"
                
                
                
            })
            UIView.addKeyframeWithRelativeStartTime(3/5, relativeDuration: 2/5, animations: {
                self.scoreBoardItem.frame.origin.x = self.view.frame.width-1
                
            })
            
            }, completion: {finished in
                // any code entered here will be applied
                // once the animation has completed
                
        })
        
    }
    

    
    override func viewDidAppear(animated: Bool) {
        
        screenWidth = self.view.frame.width
        // define view's bounds
        self.courtFieldWidth = screenWidth
        self.courtFieldHeight = (courtFieldWidth/2) // if height changes - field's ratio stays the same
        self.courtX = CGFloat(0)
        self.courtY = view.frame.height/2 - courtFieldHeight
        self.courtFrame = CGRect(x: CGFloat(courtX) , y: CGFloat(courtY), width: screenWidth, height: courtFieldHeight)
        
        self.showCourt(.Football)
        
        
        // input text fields
         team1scoreInput = UITextField(frame: CGRect(x: courtX+contentVerticalMargin,
            y: courtFrame.height+courtY+contentVerticalMargin,
            width: screenWidth/2 - (2*contentVerticalMargin),
            height: 40))
        team1scoreInput.borderStyle = UITextBorderStyle.Line
        team1scoreInput.autocapitalizationType = UITextAutocapitalizationType.Words
        team1scoreInput.text = "0"
        view.addSubview(team1scoreInput)
        
         team2scoreInput = UITextField(frame: CGRect(
            x: team1scoreInput.frame.origin.x+team1scoreInput.frame.width+contentVerticalMargin,
            y: team1scoreInput.frame.origin.y,
            width: team1scoreInput.frame.width,
            height: team1scoreInput.frame.height))
        team2scoreInput.borderStyle = UITextBorderStyle.Line
        team2scoreInput.text = "0"
        team2scoreInput.autocapitalizationType = UITextAutocapitalizationType.Words
        view.addSubview(team2scoreInput)
        
        
        
        // positioning scoreboard to the centre of the court
        let scoreboardwidth = CGFloat(100)
        let scoreboardheight = CGFloat(50)
        let scoreboardOriginY = courtY+courtField.frame.height/2-scoreboardheight/2
        let scoreboardOriginX = self.view.frame.width-1
        self.scoreBoardItem.frame =  CGRect(x: scoreboardOriginX,
            y: scoreboardOriginY,
            width: scoreboardwidth,
            height: scoreboardheight)
        
        self.scoreLabel.frame = CGRect(x: 0, y: 0, width: scoreboardwidth, height: scoreboardheight)
        self.scoreLabel.textAlignment = NSTextAlignment.Center
        
        self.scoreboardButton.frame.origin.y = self.team2scoreInput.frame.origin.y + self.team2scoreInput.frame.height+contentVerticalMargin
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //scoreboard
        
        self.scoreBoardItem.backgroundColor = UIColor.redColor()
        self.scoreLabel.text = "0:0"
        self.scoreLabel.textColor = UIColor.blackColor()
        scoreBoardItem.insertSubview(scoreLabel, atIndex: 5)
        view.insertSubview(scoreBoardItem, atIndex: 3)
        
        
        let tenisButton   = UIButton()
        tenisButton.frame = CGRectMake(contentVerticalMargin/2, contentVerticalMargin, 70, 40)
        tenisButton.backgroundColor = UIColor.blueColor()
        tenisButton.setTitle("Tenis", forState: UIControlState.Normal)
        tenisButton.addTarget(self, action: #selector(tenisButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tenisButton)
        
        let basketButton   = UIButton()
        basketButton.frame = CGRectMake(tenisButton.frame.origin.x+tenisButton.frame.width+contentVerticalMargin/2, contentVerticalMargin, 70, 40)
        basketButton.backgroundColor = UIColor.blueColor()
        basketButton.setTitle("Basket", forState: UIControlState.Normal)
        basketButton.addTarget(self, action: #selector(basketButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(basketButton)
        
        let footbalButton   = UIButton()
        footbalButton.frame = CGRectMake(basketButton.frame.origin.x+basketButton.frame.width+contentVerticalMargin/2, contentVerticalMargin, 70, 40)
        footbalButton.backgroundColor = UIColor.blueColor()
        footbalButton.setTitle("Footbal", forState: UIControlState.Normal)
        footbalButton.addTarget(self, action: #selector(footbalButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(footbalButton)
        
        
        
        scoreboardButton.frame = CGRectMake(tenisButton.frame.origin.x+tenisButton.frame.width+contentVerticalMargin/2, contentVerticalMargin, 70, 40)        
        scoreboardButton.backgroundColor = UIColor.darkGrayColor()
        scoreboardButton.setTitle("Button", forState: UIControlState.Normal)
        scoreboardButton.addTarget(self, action: #selector(animateScoreboardAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(scoreboardButton)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

