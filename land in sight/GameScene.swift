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
    var playersArr:[Player] = []
    let dice = Dice()
    var trunks: [SKSpriteNode] = []
    let squareWidth = 2048
    var turn:Int = 0
    
    public func updateGame() {
    }
    
    public func gameOver() {
    }
    override public func didMove(to view: SKView){
        if self.hasMoved{
            return
        }
        
        self.hasMoved = true
        
        guard (childNode(withName: "Tile Map Node")
                as? SKTileMapNode) != nil else {
            fatalError("Background node not loaded")
        }
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: frame.midX, y: frame.midY)
        camera.setScale(85)
        self.camera = camera
        self.addChild(camera)
        self.addChild(dice)
        createPlayers(number: 2)
        dice.initDice()
    }
    
    func createPlayers(number:Int){
        let points:[CGPoint] = [CGPoint(x: -13*squareWidth, y: -7*squareWidth), CGPoint(x: -12*squareWidth, y: -7*squareWidth)]
        for x in 0..<number{
            let player = Player()
            player.playerInit(assetName: "pirata \(x)", origin: points[x])
            playersArr.append(player)
            self.addChild(player)
            print("add player")
        }
    }
    
    func rollDice(){
        var textSeq:[SKTexture] = []
        for _ in 0...15{
            textSeq.append(SKTexture(imageNamed: "Dice \(Int.random(in: 1...6))"))
        }
        let animtion = SKAction.animate(withNormalTextures: textSeq, timePerFrame: 2)
        let rep = SKAction.repeatForever(animtion)
        dice.run(rep)
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
        scene.scaleMode = .aspectFill
        self.scene = scene
    }
    
}

