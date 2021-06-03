//
//  GameScene.swift
//  land in sight
//
//  Created by Samuel Brasileiro on 31/05/21.
//

import Foundation

import SpriteKit
import GameplayKit

public protocol GameDelegate{
    func updateGame()
    func gameOver()
}

public enum ZPosition: Int {
    case background
    case foreground
    case player
    case otherNodes
}

class StopPoint{
    var challenge: String = ""
    var consequence: String = ""
    
    var index: Int
    
    
    init(index: Int){
        self.index = index
    }
    
}

let stopPointsIndex = [2,5,7,9,11,13,16,19,23,25,28,31,33,36,38,43,45,48,52,55,57,61,64,66,68,73,77,80,83,86,91,95,99,102,105,109,111,114,117,120,123,126,130,135,141,144]

public class GameScene: SKScene, GameDelegate, GameEnvDelegate {
    
    var env: GameEnvironment!
    
    var hasMoved: Bool = false

    let squareWidth = 2048
    var turn:Int = 0
    
    var lineStraightTexture = SKTexture(imageNamed: "line_straight")
    var lineCornerTexture = SKTexture(imageNamed: "line_corner")
    var stopPointTexture = SKTexture(imageNamed: "stop_point")
    var stopPointCornerTexture = SKTexture(imageNamed: "stop_point_corner")
    
    var stopPoints /*: [StopPoint] = []*/ = [2,5,7,9,11,13,16,19,23,25,28,31,33,36,38,43,45,48,52,55,57,61,64,66,68,73,77,80,83,86,91,95,99,102,105,109,111,114,117,120,123,126,130,135,141,144]
    
    var paths: [SKNode] = []
    
    public func updateGame(){
    }
    public func gameOver(){
    }
    
    override public func didMove(to view: SKView) {
        if self.hasMoved{
            return
        }
        
        self.hasMoved = true
        
        //stopPoints = stopPointsIndex.map{StopPoint(index: $0)}
        
        guard let landBackground = childNode(withName: "Tile Map Node")
                as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        print(landBackground.mapSize)
        
        for i in 0..<149{
            guard let path = childNode(withName: String(i)) else{
                fatalError("Not loaded path node \(i)")
            }
            paths.append(path)
        }
        
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: frame.midX, y: frame.midY)
        camera.setScale(90)
        self.camera = camera
        self.addChild(camera)
        createPlayers(number: 4)
        
        reset()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            self.startPlayerMovement(index: 0, houses: 5, completion: {})
//        })
        
    }
    
    func startPlayerMovement(index:Int,houses:Int, completion: @escaping ()->Void){
        let zoomIn = SKAction.scale(by: 0.5, duration: 1)
        let moveCamera = SKAction.move(to: self.env.players[index].position, duration: 0.5)
        self.camera?.run(moveCamera)
        self.camera?.run(zoomIn,completion: {
            self.animatePlayer(index: index)
            self.movePlayer(index, houses: houses, completion: completion)
        })
    }
    
    func animatePlayer(index:Int){
        var actionSeq:[SKAction] = []
        for i in 1...2{
            let setTexture = SKAction.setTexture(SKTexture(imageNamed: "pirata-\(index)/\(i)"))
            let wait = SKAction.wait(forDuration: 0.5)
            actionSeq.append(setTexture)
            actionSeq.append(wait)
        }
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "pirata-\(index)/0"))
        let wait = SKAction.wait(forDuration: 0.5)
        actionSeq.insert(setTexture, at: actionSeq.count)
        actionSeq.insert(wait, at: 2)
        actionSeq.insert(setTexture, at: 2)
        actionSeq.insert(wait, at: 4)
        actionSeq.insert(setTexture, at: 4)
        let seq = SKAction.sequence(actionSeq)
        let rep = SKAction.repeatForever(seq)
        env.players[index].run(rep)
    }
    var flagIsInMovement: Bool = false
    
    func moveToOccupyFurther(_ index: Int){
        for i in 0..<env.players.count{
            if i != index && env.players[index].position == env.players[i].position{
                
                let action = SKAction.moveBy(x: CGFloat(squareWidth/2) + 100, y: -100, duration: 0.5)
                
                env.players[index].run(action, completion: {
                    self.moveToOccupyFurther(index)
                })
                
            }
        }
    }
    
    func movePlayer(_ index: Int, houses: Int, completion: @escaping ()->Void){
        if houses == 0{
            env.players[index].run(SKAction.setTexture(SKTexture(imageNamed: "pirata-\(index)/0")))
            env.players[index].removeAllActions()
            let zoomOut = SKAction.scale(by: 1.4, duration: 1)
            self.camera?.run(zoomOut)
            let moveCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1.5)
            self.camera?.run(zoomOut)
            self.camera?.run(moveCenter, completion: {
                self.flagIsInMovement = false
                
                completion()
                
            })
            
            moveToOccupyFurther(index)
            
            return
        }
        flagIsInMovement = true
        let player = env.players[index]
        
        let score = player.score
        
        let old = stopPoints[score]
        let next = stopPoints[score + 1]
        
        env.players[index].score += 1
        moveLine(index: index, old: old, next: next, houses: houses, completion: completion)
        
        
    }
    
    func moveLine(index: Int, old: Int, next: Int, houses: Int, completion: @escaping ()->Void){
        if old >= next{
            movePlayer(index, houses: houses - 1, completion: completion)
            return
        }
        let nextPosition = paths[old+1].position
        let action = SKAction.move(to: nextPosition, duration: 0.5)
        env.players[index].run(action, completion: {
            let moveCamera = SKAction.move(to: self.env.players[
                                            index].position, duration: 0.5)
            self.camera?.run(moveCamera)
            self.moveLine(index: index, old: old+1, next: next, houses: houses, completion: completion)
        })
        
    }
    
    func reset(){
        for i in 0..<env.players.count{
            env.players[i].position = paths[2].position
            env.players[i].position.x += CGFloat((i+1)*squareWidth)*0.5
            env.players[i].position.y -= CGFloat(i*100)
            
        }
    }
    
    func createPlayers(number:Int){
        //let points:[CGPoint] = [CGPoint(x: -12*squareWidth, y: -7*squareWidth), CGPoint(x: -11*squareWidth, y: -7*squareWidth),CGPoint(x: -11*squareWidth, y: -8*squareWidth),CGPoint(x: -12*squareWidth, y: -8*squareWidth)]
        for x in 0..<number{
            let player = Player()
            player.playerInit(assetName: "pirata-\(x)/0", origin: CGPoint(x: 0, y: 0))
            
            env.players.append(player)
            
            self.addChild(player)
            print("add player")
        }
    }
    
}

