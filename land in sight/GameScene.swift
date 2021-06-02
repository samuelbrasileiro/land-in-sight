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

public class GameScene: SKScene, GameDelegate {

    var hasMoved: Bool = false
    var players:[Player] = []
    let dice = Dice()
    var trunks: [SKSpriteNode] = []
    let squareWidth = 2048
    var turn:Int = 0
    
    var lineStraightTexture = SKTexture(imageNamed: "line_straight")
    var lineCornerTexture = SKTexture(imageNamed: "line_corner")
    var stopPointTexture = SKTexture(imageNamed: "stop_point")
    var stopPointCornerTexture = SKTexture(imageNamed: "stop_point_corner")
    
    var stopPoints /*: [StopPoint] = []*/ = [2,5,7,9,11,13,16,19,23,25,28,31,33,36,38,43,45,48,52,55,57,61,64,66,68,73,77,80,83,86,91,95,99,102,105,109,111,114,117,120,123,126,130,135,141,144]
    
    var paths: [SKNode] = []
    
    public func updateGame() {
        
    }
    public func gameOver() {

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
        createPlayers(number: 2)
        
        reset()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.movePlayer(0, houses: 10)
        })
        
    }
    var flagIsInMovement: Bool = false
    func movePlayer(_ index: Int, houses: Int){
        if houses == 0{
            flagIsInMovement = false
            return
        }
        flagIsInMovement = true
        let player = players[index]
        
        let score = player.score
        
        let old = stopPoints[score]
        let next = stopPoints[score + 1]
        
        players[index].score += 1
        moveLine(index: index, old: old, next: next, houses: houses)
        
        
    }
    
    func moveLine(index: Int, old: Int, next: Int, houses: Int){
        if old >= next{
            movePlayer(index, houses: houses - 1)
            return
        }
        let nextPosition = paths[old+1].position
        let action = SKAction.move(to: nextPosition, duration: 0.5)
        players[index].run(action, completion: {
            self.moveLine(index: index, old: old+1, next: next, houses: houses)
        })
        
        
        
    }
    
    func reset(){
        for i in 0..<players.count{
            players[i].position = paths[0].position
            players[i].position.x += CGFloat(i*squareWidth)*0.5
            players[i].position.y -= CGFloat(i*100)
            
        }
    }
    
    func createPlayers(number:Int){
            let points:[CGPoint] = [CGPoint(x: -13*squareWidth, y: -7*squareWidth), CGPoint(x: -12*squareWidth, y: -7*squareWidth)]
            for x in 0..<number{
                let player = Player()
                player.playerInit(assetName: "pirata \(x)", origin: points[x])
                
                players.append(player)
                
                self.addChild(player)
                print("add player")
            }
        }
    
    
}


public class GameSceneLoader: ObservableObject{
    @Published public var scene: GameScene = GameScene()
//    public init(){
//        
//    }
    public init(/*environment: GameEnvironment*/){
        reset(/*environment*/)
    }
    public func reset(/*_ environment: GameEnvironment*/){
        guard let scene = GameScene(fileNamed: "MyScene.sks") else{
            fatalError("Did not load scene")
        }
        //let scene = GameScene(size: CGSize(width: 800, height: 500))
        
        //scene.environment = environment
        scene.scaleMode = .aspectFill
        self.scene = scene
    }
    
}

