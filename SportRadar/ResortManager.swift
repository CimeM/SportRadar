//
//  ResortManager.swift
//  SportRadar
//
//  Created by Martin Cimerman on 04/06/16.
//  Copyright © 2016 Martin Cimerman. All rights reserved.
//

//import Foundation
import UIKit
//import QuartzCore

protocol MatchPitchProtocol {
    func setresultForHome(score: Int)
    func setresultForAway(score: Int)
}

class ResortManager:  UIView, MatchPitchProtocol  {

    enum CourtType {
        case Tenis
        case Basketball
        case Football
        case notDefined
    }
    
    var gameManager = GameManager()
    let scoreBoard = CALayer()
    let scoreText = CATextLayer()
    var animationRunning = false
    func setresultForHome(score: Int) {
        self.gameManager.scoreTeam1 = score
    }
    func setresultForAway(score: Int) {
        self.gameManager.scoreTeam2 = score
    }
    
    var typeOfCourt : CourtType
    //var courtOuterFrame : CGRect

    
    init(frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100),
         courtType: CourtType = .Basketball) {
        
        self.typeOfCourt = courtType
        super.init(frame: frame)
        
        self.scoreBoard.frame = CGRect(x: -100, y: 50, width: 100, height: 50)
        self.scoreBoard.backgroundColor = UIColor.blueColor().CGColor
        self.scoreText.string = "\(gameManager.scoreTeam1):\(gameManager.scoreTeam2)"
        self.scoreText.frame = self.scoreBoard.frame
        self.scoreText.frame.origin = CGPoint(x:0, y:0)
        self.scoreText.alignmentMode = "center"
        //layer.insertSublayer(self.scoreBoard, atIndex: 2)
        scoreBoard.addSublayer(self.scoreText)
        self.layer.addSublayer(self.scoreBoard)
        
    }
    
    func showScoreboard() {
        
        let fromValue = self.scoreBoard.frame.origin.x
        let toValue = frame.width/2 - scoreBoard.frame.width/2 // to center
        scoreBoard.speed = 0.5
        self.scoreBoard.frame.origin.x = toValue
        let positionAnimation = CABasicAnimation(keyPath: "frame.origin.x")
        
        positionAnimation.fromValue = fromValue
        positionAnimation.toValue = toValue
        
        self.scoreBoard.addAnimation(positionAnimation, forKey: "frame.origin.x")

        
    }
    
    func updateScorelabel() {
        
        let fromValue = self.scoreText
        let toValue = "\(self.gameManager.scoreTeam1):\(self.gameManager.scoreTeam2)"

        scoreText.speed = 1
        self.scoreText.string = toValue
        let positionAnimation = CABasicAnimation(keyPath: "string")
        
        positionAnimation.fromValue = fromValue
        positionAnimation.toValue = toValue

        self.scoreBoard.addAnimation(positionAnimation, forKey: "string")
        
        //_ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ResortManager.hideScoreboard), userInfo: nil, repeats: false)
        
    }

    func hideScoreboard() {
        let fromValue = self.scoreBoard.frame.origin.x
        let toValue = frame.width
        scoreBoard.speed = 0.5
        self.scoreBoard.frame.origin.x = toValue
        let positionAnimation = CABasicAnimation(keyPath: "frame.origin.x")
        
        positionAnimation.fromValue = fromValue
        positionAnimation.toValue = toValue
        
        self.scoreBoard.addAnimation(positionAnimation, forKey: "frame.origin.x")

        //_ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ResortManager.resetScoreboard), userInfo: nil, repeats: false)
    }
    
    func resetScoreboard(){
        let fromValue = self.scoreBoard.frame.origin.x
        let toValue = 0 - scoreBoard.frame.width
        CATransaction.setDisableActions(true)
        print(time)
        scoreBoard.speed = 100
        self.scoreBoard.frame.origin.x = toValue
        let positionAnimation = CABasicAnimation(keyPath: "frame.origin.x")
        
        positionAnimation.fromValue = fromValue
        positionAnimation.toValue = toValue
        
        self.scoreBoard.addAnimation(positionAnimation, forKey: "frame.origin.x")
        
    }
    
    func scoreBoardAnimation() {
        
        //animation timeframes
        let showScoreboardAtTime            = NSTimeInterval(0)
        let updateScoreboardLabelAtTime     = NSTimeInterval(1)
        let hideScoreboardAtTime            = NSTimeInterval(2)
        let resetScoreboardPositionAtTime   = NSTimeInterval(3)
        let resetAnimationRunningFlag       = NSTimeInterval(4)
        
        if animationRunning == false {
            self.animationRunning = true
            _ = NSTimer.scheduledTimerWithTimeInterval(showScoreboardAtTime, target: self,
                                                       selector: #selector(ResortManager.showScoreboard),
                                                       userInfo: nil, repeats: false)
            
            _ = NSTimer.scheduledTimerWithTimeInterval(updateScoreboardLabelAtTime, target: self,
                                                       selector: #selector(ResortManager.updateScorelabel),
                                                       userInfo: nil, repeats: false)
            
            _ = NSTimer.scheduledTimerWithTimeInterval(hideScoreboardAtTime, target: self,
                                                       selector: #selector(ResortManager.hideScoreboard),
                                                       userInfo: nil, repeats: false)
            
            _ = NSTimer.scheduledTimerWithTimeInterval(resetScoreboardPositionAtTime, target: self,
                                                       selector: #selector(ResortManager.resetScoreboard),
                                                       userInfo: nil, repeats: false)
            _ = NSTimer.scheduledTimerWithTimeInterval(resetAnimationRunningFlag, target: self,
                                                       selector: #selector(ResortManager.resetAnimationRuningFlag),
                                                       userInfo: nil, repeats: false)
            
        }
        
    }
    
    func resetAnimationRuningFlag () {
    
        self.animationRunning = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
            UIColor.whiteColor().setStroke()
            let courtFieldPadding = CGFloat(10)
        
        if typeOfCourt == .Tenis {
            
            let bbCourtWidth = 72.0 //width should be =< 2x court_height
            let bbCourtHeight = 36.0
            let fieldRatio = CGFloat(bbCourtWidth/bbCourtHeight) //basketball 94/50 (NCAA)
            
            // main frame dimentions
            let courtHeigth = rect.height - ( 2*courtFieldPadding )
            let courtWidth = fieldRatio*courtHeigth
            let courtX = (rect.width/2) - (courtWidth/2)
            let courtY = (rect.height/2) - (courtHeigth/2)
            let feetToPixelRatio = Double(courtWidth)/bbCourtWidth
            
            // draw main frame
            let courtFrame = UIBezierPath()
            courtFrame.moveToPoint(CGPoint(x: courtX, y: courtY))
            courtFrame.addLineToPoint(CGPoint(x: courtX + courtWidth, y: courtY))
            courtFrame.addLineToPoint(CGPoint(x: courtX + courtWidth, y: courtY+courtHeigth))
            courtFrame.addLineToPoint(CGPoint(x: courtX , y: courtY+courtHeigth))
            
            courtFrame.closePath()
            courtFrame.stroke()
            
            //singles Side Lines
            let ssLines = UIBezierPath()
            let ssLineXTranslation = CGFloat(13 * feetToPixelRatio)// singles line tr. from center (y)
            let ssLStartPoint = CGPoint(x: courtX, y: courtY + courtHeigth/2  - ssLineXTranslation)
            ssLines.moveToPoint(ssLStartPoint)
            ssLines.addLineToPoint(CGPoint(x: ssLStartPoint.x+courtWidth, y: ssLStartPoint.y))
            ssLines.addLineToPoint(CGPoint(x: ssLStartPoint.x+courtWidth, y: ssLStartPoint.y+(2*ssLineXTranslation)))
            ssLines.addLineToPoint(CGPoint(x: ssLStartPoint.x, y: ssLStartPoint.y+(2*ssLineXTranslation)))
            ssLines.stroke()
            
            
            // service lines
            let serviceLineXMargin = CGFloat(18*feetToPixelRatio)
            let slStart = CGPoint(x:ssLStartPoint.x+serviceLineXMargin, y: courtY+courtHeigth/2 )
            let serviceLines = UIBezierPath()
            serviceLines.moveToPoint(slStart)
            serviceLines.addLineToPoint(CGPoint(x:slStart.x, y:ssLStartPoint.y))
            serviceLines.addLineToPoint(CGPoint(x:slStart.x+courtWidth-2*serviceLineXMargin, y:ssLStartPoint.y))
            serviceLines.addLineToPoint(CGPoint(x:slStart.x+courtWidth-2*serviceLineXMargin, y:slStart.y))
            serviceLines.addLineToPoint(slStart)
            serviceLines.addLineToPoint(CGPoint(x:slStart.x, y:ssLStartPoint.y+(2*ssLineXTranslation)))
            serviceLines.addLineToPoint(CGPoint(x:slStart.x+courtWidth-2*serviceLineXMargin, y:ssLStartPoint.y+(2*ssLineXTranslation)))
            serviceLines.addLineToPoint(CGPoint(x:slStart.x+courtWidth-2*serviceLineXMargin, y:ssLStartPoint.y+(2*ssLineXTranslation)))
            serviceLines.addLineToPoint(CGPoint(x:slStart.x+courtWidth-2*serviceLineXMargin, y:slStart.y))
            serviceLines.stroke()
            
            
            //center line
            let centerLine = UIBezierPath()
            centerLine.moveToPoint(CGPoint(x: courtX+(courtWidth/2), y: courtY))
            centerLine.addLineToPoint(CGPoint(x: courtX+(courtWidth/2), y: courtY+courtHeigth))
            centerLine.stroke()
        }
        else if typeOfCourt == .Football {
            
            let fbCourtWidth = 100.0
            let fbCourtHeight = 50.0
            let fieldRatio = CGFloat(fbCourtWidth/fbCourtHeight) //footbal 2/1 (NCAA)
            
            // main frame dimentions
            let courtHeigth = rect.height - ( 2*courtFieldPadding )
            let courtWidth = fieldRatio*courtHeigth
            let courtX = (rect.width/2) - (courtWidth/2)
            let courtY = (rect.height/2) - (courtHeigth/2)
            let feetToPixelRatio = Double(courtWidth)/fbCourtWidth
            
            let mirrorOverXOrigin = CGAffineTransformMakeScale(-1.0, 1.0)
            let translate = CGAffineTransformMakeTranslation(courtWidth+(courtX*2), 0)
            
            
            // draw main frame
            let courtFrame = UIBezierPath()
            courtFrame.moveToPoint(CGPoint(x: courtX, y: courtY))
            courtFrame.addLineToPoint(CGPoint(x: courtX + courtWidth, y: courtY))
            courtFrame.addLineToPoint(CGPoint(x: courtX + courtWidth, y: courtY+courtHeigth))
            courtFrame.addLineToPoint(CGPoint(x: courtX , y: courtY+courtHeigth))
            courtFrame.closePath()
            courtFrame.stroke()
            
            //center line
            let centerLine = UIBezierPath()
            centerLine.moveToPoint(CGPoint(x: courtX+(courtWidth/2), y: courtY))
            centerLine.addLineToPoint(CGPoint(x: courtX+(courtWidth/2), y: courtY+courtHeigth))
            centerLine.stroke()
            
            
            //center Circle
            let centerCircle = UIBezierPath()
            centerCircle.addArcWithCenter( CGPoint(x: rect.width/2, y: rect.height/2) ,
                                           radius: CGFloat(10*feetToPixelRatio),
                                           startAngle: 0,
                                           endAngle: CGFloat(2*M_PI),
                                           clockwise: true)
            centerCircle.stroke()
            
            
            // penalty area
            let penaltyAreaWidth = CGFloat((44/2) * feetToPixelRatio)
            let penaltyAreaHeight = CGFloat(18*feetToPixelRatio)
            let penaltyArea = UIBezierPath()
            penaltyArea.moveToPoint(CGPoint(x: courtX,
                y: courtY+courtHeigth/2-penaltyAreaWidth))
            penaltyArea.addLineToPoint(CGPoint(x: courtX + penaltyAreaHeight,
                y: courtY+courtHeigth/2-penaltyAreaWidth))
            penaltyArea.addLineToPoint(CGPoint(x: courtX + penaltyAreaHeight,
                y: courtY+courtHeigth/2+penaltyAreaWidth))
            penaltyArea.addLineToPoint(CGPoint(x: courtX ,
                y: courtY+courtHeigth/2+penaltyAreaWidth))
            
            penaltyArea.stroke()
            
            //mirror penalty area
            penaltyArea.applyTransform(mirrorOverXOrigin)
            penaltyArea.applyTransform(translate)
            penaltyArea.stroke()
            
            
            // goal area
            let goalAreaWidth = CGFloat((20/2) * feetToPixelRatio)
            let goalAreaHeight = CGFloat(6*feetToPixelRatio)
            let goalArea = UIBezierPath()
            goalArea.moveToPoint(CGPoint(x: courtX,
                y: courtY+courtHeigth/2-goalAreaWidth))
            goalArea.addLineToPoint(CGPoint(x: courtX + goalAreaHeight,
                y: courtY+courtHeigth/2-goalAreaWidth))
            goalArea.addLineToPoint(CGPoint(x: courtX + goalAreaHeight,
                y: courtY+courtHeigth/2+goalAreaWidth))
            goalArea.addLineToPoint(CGPoint(x: courtX ,
                y: courtY+courtHeigth/2+goalAreaWidth))
            
            goalArea.stroke()
            
            //mirror goal area
            goalArea.applyTransform(mirrorOverXOrigin)
            goalArea.applyTransform(translate)
            goalArea.stroke()
            
            
            //penalty area Arch
            let penaltyAreaArch = UIBezierPath()
            penaltyAreaArch.addArcWithCenter( CGPoint(x: courtX + CGFloat(12*feetToPixelRatio),
                y: courtY + courtHeigth/2) ,
                                           radius: CGFloat(10*feetToPixelRatio),
                                           startAngle: CGFloat(8.5*M_PI/5),
                                           endAngle: CGFloat(1.5*M_PI/5),
                                           clockwise: true)
            penaltyAreaArch.stroke()
            
            
            //mirror goal area
            penaltyAreaArch.applyTransform(mirrorOverXOrigin)
            penaltyAreaArch.applyTransform(translate)
            penaltyAreaArch.stroke()
            
        }
        else if typeOfCourt == .Basketball {
            
                let bbCourtWidth = 94.0
                let bbCourtHeight = 50.0
                let fieldRatio = CGFloat(bbCourtWidth/bbCourtHeight) //basketball 94/50 (NCAA)
            
                
                // main frame dimentions
                let courtHeigth = rect.height - ( 2*courtFieldPadding )
                let courtWidth = fieldRatio*courtHeigth
                let courtX = (rect.width/2) - (courtWidth/2)
                let courtY = (rect.height/2) - (courtHeigth/2)
                let feetToPixelRatio = Double(courtWidth)/bbCourtWidth
                
                let mirrorOverXOrigin = CGAffineTransformMakeScale(-1.0, 1.0)
                let translate = CGAffineTransformMakeTranslation(courtWidth+(courtX*2), 0)
                
                // draw main frame
                let courtFrame = UIBezierPath()
                courtFrame.moveToPoint(CGPoint(x: courtX, y: courtY))
                courtFrame.addLineToPoint(CGPoint(x: courtX + courtWidth, y: courtY))
                courtFrame.addLineToPoint(CGPoint(x: courtX + courtWidth, y: courtY+courtHeigth))
                courtFrame.addLineToPoint(CGPoint(x: courtX , y: courtY+courtHeigth))
                courtFrame.closePath()
                courtFrame.stroke()
                
                
                //center line
                let centerLine = UIBezierPath()
                centerLine.moveToPoint(CGPoint(x: courtX+(courtWidth/2), y: courtY))
                centerLine.addLineToPoint(CGPoint(x: courtX+(courtWidth/2), y: courtY+courtHeigth))
                centerLine.stroke()
                
                
                //center Circle
                let centerCircle = UIBezierPath()
                centerCircle.addArcWithCenter( CGPoint(x: rect.width/2, y: rect.height/2) ,
                                               radius: CGFloat(6*feetToPixelRatio),
                                               startAngle: 0,
                                               endAngle: CGFloat(2*M_PI),
                                               clockwise: true)
                centerCircle.stroke()
                
                
                //threepointLine
                let archRadius = CGFloat(19*feetToPixelRatio)
                let threePointLine = UIBezierPath()
                let threepointLineStart = CGPoint(x: courtX, y: courtY + courtHeigth/2 - CGFloat(archRadius))
                let threepointLinep1 = CGPoint(x: threepointLineStart.x+CGFloat(8*feetToPixelRatio) ,y: threepointLineStart.y )
                
                threePointLine.moveToPoint( threepointLineStart )
                
                threePointLine.addArcWithCenter(
                    CGPoint(x: threepointLinep1.x, y: threepointLinep1.y+archRadius) ,
                    radius: archRadius,
                    startAngle: CGFloat(3*M_PI/2),
                    endAngle: CGFloat(M_PI/2),
                    clockwise: true)
                threePointLine.addLineToPoint(CGPoint(x: threepointLineStart.x, y: threepointLineStart.y+CGFloat(2*archRadius) ) )
                
                threePointLine.stroke()
                
                //mirror three point line
                threePointLine.applyTransform(mirrorOverXOrigin)
                threePointLine.applyTransform(translate)
                threePointLine.stroke()
            
                
                //two point line
                let twoPArchRadius = CGFloat(6*feetToPixelRatio)
                let twoPLines = UIBezierPath()
                let twoPLineStart = CGPoint(x: courtX, y: courtY+(courtHeigth/2)-(twoPArchRadius))
                let twoPLineP1 = CGPoint(x: twoPLineStart.x+CGFloat(19*feetToPixelRatio), y: twoPLineStart.y)
                
                twoPLines.moveToPoint(twoPLineStart)
                twoPLines.addLineToPoint(CGPoint(x: twoPLineP1.x, y: twoPLineStart.y))
                twoPLines.addLineToPoint(CGPoint(x: twoPLineP1.x, y: twoPLineStart.y+twoPArchRadius*2))
                twoPLines.addArcWithCenter(
                    CGPoint(x: twoPLineP1.x, y: twoPLineP1.y+twoPArchRadius) ,
                    radius: twoPArchRadius,
                    startAngle: CGFloat(3*M_PI/2),
                    endAngle: CGFloat(M_PI/2),
                    clockwise: true)
                twoPLines.addLineToPoint(CGPoint(x:twoPLineStart.x, y:twoPLineStart.y+(2*twoPArchRadius)))
                twoPLines.closePath()
                twoPLines.stroke()
                
                //mirror two point line
                twoPLines.applyTransform(mirrorOverXOrigin)
                twoPLines.applyTransform(translate)
                twoPLines.stroke()
                
                
                //basket arch
                let basketArchRadius = CGFloat(3*feetToPixelRatio)
                let basketArch = UIBezierPath()
                
                let basketArchStartPoint = CGPoint(x: courtX+CGFloat(4*feetToPixelRatio), y: courtY+(courtHeigth/2))
                //basketArch.moveToPoint(basketArchStartPoint)
                basketArch.addArcWithCenter(
                    basketArchStartPoint ,
                    radius: basketArchRadius,
                    startAngle: CGFloat(3*M_PI/2),
                    endAngle: CGFloat(M_PI/2),
                    clockwise: true)
                basketArch.stroke()
                
                //mirror basket arch
                basketArch.applyTransform(mirrorOverXOrigin)
                basketArch.applyTransform(translate)
                basketArch.stroke()
                
                
                // basket imprint
                let basketRadius = CGFloat(0.6*feetToPixelRatio)
                let basketImprint = UIBezierPath()
                let basketImprintLength = CGFloat(1.5*feetToPixelRatio)
                let basketStartPoint = CGPoint(x: basketArchStartPoint.x, y: courtY+(courtHeigth/2)+basketImprintLength)
                
                basketImprint.moveToPoint(basketStartPoint)
                basketImprint.addLineToPoint(CGPoint(x: basketStartPoint.x, y: basketStartPoint.y-(2*basketImprintLength)))
                basketImprint.addLineToPoint(CGPoint(x: basketStartPoint.x, y: basketStartPoint.y-(basketImprintLength)))
                basketImprint.addArcWithCenter(
                    CGPoint(x: basketStartPoint.x+CGFloat(1*feetToPixelRatio), y: basketStartPoint.y-(basketImprintLength)) ,
                    radius: basketRadius,
                    startAngle: CGFloat(M_PI),
                    endAngle: CGFloat(4*M_PI),
                    clockwise: true)
                basketImprint.stroke()
                
                //mirror basket
                basketImprint.applyTransform(mirrorOverXOrigin)
                basketImprint.applyTransform(translate)
                basketImprint.stroke()
            
        }
        else {
            //TBD
            
        }
    
    }


}

