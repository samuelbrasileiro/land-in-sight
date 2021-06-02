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

public class GameScene: SKScene, GameDelegate {

    var hasMoved: Bool = false
    
    var trunks: [SKSpriteNode] = []
    
    //var landBackground:SKTileMapNode!
    
    var lineStraightTexture = SKTexture(imageNamed: "line_straight")
    var lineCornerTexture = SKTexture(imageNamed: "line_corner")
    var stopPointTexture = SKTexture(imageNamed: "stop_point")
    var stopPointCornerTexture = SKTexture(imageNamed: "stop_point_corner")
    
    
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

        print(landBackground.mapSize)
        //landBackground.setScale(1/75)

        //x -31 31 y -15 15
        
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: frame.midX, y: frame.midY)
        camera.setScale(77)
        self.camera = camera
        self.addChild(camera)
        
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

