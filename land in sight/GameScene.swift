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

public class GameScene: SKScene, GameDelegate {
    
    var hasMoved: Bool = false
    var playerRect = Player()
    var trunks: [SKSpriteNode] = []
    
    public func updateGame() {
    }
    
    public func gameOver() {
    }
    
    override public func didMove(to view: SKView) {
        if self.hasMoved{
            return
        }
        
        self.hasMoved = true
        
        guard let landBackground = childNode(withName: "Tile Map Node")
                as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        playerRect.playerInit(assetName:"pirata 2", origin:CGPoint(x: 0, y: 0))
        self.addChild(playerRect)
        let camera = SKCameraNode()
        camera.position = CGPoint(x: frame.midX, y: frame.midY)
        camera.setScale(77)
        self.camera = camera
        self.addChild(camera)
        let path:[CGPoint] = [CGPoint(x: 0*1024, y: 1*1024), CGPoint(x: 0*1024, y: 2*1024),CGPoint(x: 1*1024, y: 2*1024),CGPoint(x: 1*1024, y: 3*1024)]
        movePlayer(path: path)
        
    }
    
    func movePlayer(path:[CGPoint]?){
        var actionSeqArr:[SKAction] = []
        if let validPah = path{
            for point in validPah{
                let action = SKAction.move(to: point, duration: 2)
                actionSeqArr.append(action)
            }
            let actionSeq = SKAction.sequence(actionSeqArr)
            playerRect.run(actionSeq)
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

