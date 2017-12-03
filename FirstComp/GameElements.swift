//
//  GameElements.swift
//  FirstComp
//
//  Created by abhishek on 9/24/17.
//  Copyright © 2017 abhishek. All rights reserved.
//
 import SpriteKit

struct  collisionBitMask {
    static var player : UInt32 = 0x00

    static var obstacle : UInt32 = 0x01
    
    
}

enum ObstacleType: Int {
case car = 0
    
}

enum RowType: Int {
case CarOnLeft = 0
    case CarOnRight = 1
    
}

extension GameScene {
    
    func addScoreBanner() {
        ScoreBanner = SKSpriteNode(color : UIColor.cyan, size: CGSize(width:player.size.width * 2 ,height: player.size.height * 0.33)  )
        ScoreBanner.position = CGPoint(x: self.size.width/2 - ScoreBanner.size.width/2 , y: self.size.height - ScoreBanner.size.height/2)
ScoreBanner.name = "ScoreBanner"
        self.addChild(ScoreBanner)
    
        writeonscore = SKLabelNode(fontNamed: "Chalkduster")
        writeonscore.text = " score is 0"
        writeonscore.fontColor = SKColor.black
        writeonscore.position =  CGPoint(x: self.size.width/2 - ScoreBanner.size.width/2 , y: self.size.height - ScoreBanner.size.height/2)
self.addChild(writeonscore)
    }

    func addPlayer() {
    
        player = SKSpriteNode(color: UIColor.red, size: CGSize(width: 150 , height: 191))
        // on right side works like charm
       // player.position = CGPoint(x :   self.size.width * (3/4) - player.size.width ,y: 250)
        player.position = CGPoint(x :   self.size.width * (1/4) + player.size.width,y: self.size.height * (250/1080))
        //        player.position = CGPoint(x :   self.size.width * (1/4) + player.size.width,y: 250)

        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = collisionBitMask.player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = collisionBitMask.obstacle
        player.texture = SKTexture(imageNamed: "car1")
        addChild(player)
        initialPlayerPosition = player.position
        print("Size of player ", player.size," osition of playe ", player.position)
        
          }
    
    
    
    
    
    func addObstacle(type : ObstacleType) -> SKSpriteNode {
        let obstacle = SKSpriteNode(color : UIColor.black, size:  CGSize(width: 150 , height: 191))
    
    obstacle.name = "obstacle"
        obstacle.physicsBody?.isDynamic = true
        switch type {
        case .car:
            break
       
        }
    
        obstacle.position = CGPoint(x:0 + player.size.width ,y: self.size.height + obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = collisionBitMask.obstacle
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.texture = SKTexture(imageNamed:"car2")
        
    return obstacle
    }
    
    
    func addMovement(obstacle: SKSpriteNode)
    {
    
    var actionArray = [SKAction]()
        // was 3
        actionArray.append(SKAction.move(to : CGPoint(x: obstacle.position.x,y: -obstacle.size.height), duration: TimeInterval(ms1.speed)))
        actionArray.append(SKAction.removeFromParent())
        obstacle.run(SKAction.sequence(actionArray))
    }
    func addRow(type: RowType) {
    Score += 1
        switch type {
        case .CarOnLeft:
            let  obst = addObstacle(type: .car)
            obst.position = CGPoint(x :   self.size.width * (1/4) + player.size.width,y: self.size.height + obst.size.height)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .CarOnRight:
            let  obst = addObstacle(type: .car)
            obst.position = CGPoint(x :   self.size.width * (3/4) - player.size.width ,y: self.size.height + obst.size.height)
            addMovement(obstacle: obst)
            addChild(obst)

            break
        }
    }
 
}
