//
//  GameScene.swift
//  FirstComp
//
//  Created by abhishek on 9/24/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    var ScoreBanner : SKSpriteNode!
    
    var writeonscore : SKLabelNode!

    var player : SKSpriteNode!
    
    var initialPlayerPosition : CGPoint!
    
    let dfaults : UserDefaults = UserDefaults.standard
    
   // var ms0 = motionsetter(space: 1.0, speed: 3)
    var ms1 =  motionsetter(space:1.0,speed:3)
    var onceUpdated : Bool = true
    

    var Score : Int = 0
    
    public var  YourScoreWas : Int = 0
    
    var limmiter = 40
    
    override func didMove(to view: SKView) {
        //intial configuration  1.0 and  3 medium
        // 1.4 and 4 ample space slow
        // space 0.7 and speed 2 is fast
        ms1.space = 1.0
        ms1.speed = 3
        
        limmiter = randomNumberBetween(start:40,end:50)
        
        Score = 1
        self.backgroundColor = UIColor.white
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        physicsWorld.contactDelegate = self
 //     print("Now Size is ", self.size)
        addPlayer()
        addScoreBanner()
        
        
        // addRow(type: .CarOnRight)
        
        let swipeRight  = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRecognizer))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRecognizer))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
    }
    
    func respondToSwipeRecognizer(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch  swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if (player.position.x == self.size.width * (1/4) + player.size.width )
                {
                    player.position = CGPoint(x :   self.size.width * (3/4) - player.size.width ,y: 250)
                //    print("I was here")
                }
            case UISwipeGestureRecognizerDirection.left:
                if (player.position.x == self.size.width * (3/4) - player.size.width  )
                {
                    player.position = CGPoint(x :   self.size.width * (1/4) + player.size.width ,y: 250)
                 //   print("I was here 2")
                    
                }
            default:
                print("something unknown")
            }
        }
    }
    func resetPlayerPosition() {
        
        player.position = initialPlayerPosition
        
    }
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    
    func updateWithTimeScienceLastUpdate(timeScienceLastUpdate : TimeInterval, youhaveto : Bool, space: Double){
        
        lastYieldTimeInterval += timeScienceLastUpdate
        //chabging 0.9 to 0.6 will decrease the space betewwn blocks the number chsnges distance between blocks
        // was 1.0
        if lastYieldTimeInterval > space, youhaveto
        {
            print("lastYieldTimeInterval \(lastYieldTimeInterval) row added at  \(lastYieldTimeInterval)")

            lastYieldTimeInterval = 0
            addRandomRow()
            
        }
        writeonscore.text = " score is \(currentScoreIs())"

        
    }
    func updateWithTimeScienceLastUpdate2(timeScienceLastUpdate : TimeInterval, youhaveto : Bool, space: Double){
        
        lastYieldTimeInterval += timeScienceLastUpdate
        //chabging 0.9 to 0.6 will decrease the space betewwn blocks the number chsnges distance between blocks
        // was 1.0
        if lastYieldTimeInterval > space, youhaveto
        {
            print("lastYieldTimeInterval2 \(lastYieldTimeInterval) row added at  \(lastYieldTimeInterval)")
            
            lastYieldTimeInterval = 0
            
        }
        writeonscore.text = " score is \(currentScoreIs())"
        
        
    }

    var cc = 0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        var timeScienceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeScienceLastUpdate > 1{
            print("timeScienceLastUpdate \(timeScienceLastUpdate) lastUpdateTimeInterval \(lastUpdateTimeInterval)")

            // was 60
            timeScienceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
            
        }
        
        if (currentScoreIs() < limmiter){
        updateWithTimeScienceLastUpdate(timeScienceLastUpdate: timeScienceLastUpdate,youhaveto: true,space:  ms1.space)
            cc = 1
        }
        else
        {
        
    
      
            if cc < 3{
          
           
                SKAction.removeFromParent()

            
                for child in self.children {
                    if let spriteNode = child as? SKSpriteNode, spriteNode.name == "obstacle" {
                        //      print(spriteNode.position)
                        
                            
                        spriteNode.removeFromParent()
                    
                        
                    }
                }
                cc += 1
                writeonscore.text = "Next Level"

            }
            else{
                ms1.space = 0.7
                ms1.speed = 2
                updateWithTimeScienceLastUpdate(timeScienceLastUpdate: timeScienceLastUpdate,youhaveto: true,space:  ms1.space)

            }
        }
        
        
    }
    
    func randomNumberBetween(start:Int, end:Int) -> Int {
    
        let s = end - start
        
let lol = Int(arc4random_uniform(UInt32(s)) + UInt32(start))
 
        return lol
    }
    
    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(2))
        
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        default:
            break
            
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "PLAYER"
        {
        //    print("Game Over")
        }
        ShowGameOver()
    }
    
    func ShowGameOver()
    {
        var dude = 0
        let obstacles = self.children.count - 2
        
        dude = checkIfAnyThingIsBelowPlayer()
       // print("Score is ",(Score - obstacles + dude) , "Number of nodes are ", self.children.count)
        
        let  YourScoreWas = Score - obstacles + dude
      //  print("score \(Score) self.children.count \(obstacles) dude \(dude)")

       // print("your score in game over \(YourScoreWas) current score is \(currentScoreIs())")

        saveScore(value: YourScoreWas)
        let transition = SKTransition.fade(withDuration: 0.5)
        
        let gameOverScene = GameOverScene(size : self.size)
        
        //        if(dfaults.integer(forKey: "YourScoreWas") != 0)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    
    func saveScore(value : Int) {
       // print(value)
        
        dfaults.set(value, forKey: "YourScoreWas")
        
      //  print("got from userdefaults ", dfaults.integer(forKey: "YourScoreWas"))
        
        Score = 0
        
        if dfaults.integer(forKey: "HighScore") == 0{
        
        dfaults.set(value, forKey: "HighScore")
        }
        else
        {
        if dfaults.integer(forKey: "HighScore") < value
        {
            
            dfaults.set(value, forKey: "HighScore")
          //  print("High Score is ", dfaults.integer(forKey: "HighScore"))
            }
        }

    
    
    }
    
    func checkIfAnyThingIsBelowPlayer() -> Int {
    
        let theEndPoint = CGPoint(x :   self.size.width * (1/4) + player.size.width,y: self.size.height * (250/1080))
     //   print(theEndPoint)

        
        for child in self.children {
            if let spriteNode = child as? SKSpriteNode, spriteNode.name == "obstacle" {
          //      print(spriteNode.position)
                if (spriteNode.position.y < theEndPoint.y) {
              //      print("something is here")
                    return 1
                }
            }
        }
        return 0

    }
    func currentScoreIs() -> Int {
        let obstacles = self.children.count - 2

     //   print("in current score \(Score) self.children.count \(self.children.count) dude \(checkIfAnyThingIsBelowPlayer())")

        let  YourScoreWas = Score - obstacles + checkIfAnyThingIsBelowPlayer()
     /*   if YourScoreWas > 20, onceUpdated
        {
        updateSpeed()
        onceUpdated = false
        }
       */
        
        return YourScoreWas
        
    }
    
    
    
func updateSpeed()
{
    
    ms1.space = 0.7
    ms1.speed = 2
    
}
    
    
}

struct motionsetter {
    var space : Double
    var speed : Int
    }
