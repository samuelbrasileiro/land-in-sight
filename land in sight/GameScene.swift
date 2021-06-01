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

var visitedPoints: [CGPoint] = []

class StopPoint{
    var challenge: String = ""
    var consequence: String = ""
    
    var position: CGPoint
    
    var lineToEnd: [CGPoint]?
    
    init(position: CGPoint){
        self.position = position
    }
    
    //(5, 10)     (12, 13)
    func getLinePositions(final: CGPoint) -> [CGPoint]{
        var x = final.x - position.x
        var y = final.y - position.y
        
        var movements: [CGPoint] = []
        
        while abs(x) > 0{
            movements.append(CGPoint(x: (x >= 0 ? 1 : -1), y: 0))
            x += (x >= 0 ? -1 : 1)
        }
        while abs(y) > 0{
            movements.append(CGPoint(x: 0, y: (y >= 0 ? 1 : -1)))
            y += (y >= 0 ? -1 : 1)
        }
        //[(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(0,1),(0,1),(0,1)]
        
        
        var start = position
        
        var positions: [CGPoint] = []

            movements.shuffle()
            positions = []
                        
            for movement in movements{
                start.x += movement.x
                start.y += movement.y
                
                positions.append(start)
                if visitedPoints.contains(start){
                    print("CONFLITOU ALGUMA VEZ NO \(start)")
                    break
                }
                
            }
        
        return positions
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
        let points = [StopPoint(position: CGPoint(x: -20, y: 10)),StopPoint(position: CGPoint(x: -10, y: -10)), StopPoint(position: CGPoint(x: 0, y: 5)), StopPoint(position: CGPoint(x: 20, y: 10))]
        
        var linesPositions: [(CGPoint, Bool)] = []
        linesPositions.append((points[0].position, true))
        for i in 0..<points.count-1{
            
            let lp = points[i].getLinePositions(final: points[i+1].position)
            points[i].lineToEnd = lp
            
            linesPositions.append(contentsOf: lp.dropLast().map{($0, false)})
            linesPositions.append((points[i].position, true))
        }
        
        
        printMap(positions: linesPositions)
        
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: frame.midX, y: frame.midY)
        camera.setScale(77)
        self.camera = camera
        self.addChild(camera)
        
    }
    
    func printMap(positions: [(CGPoint, Bool)]){
        if positions.isEmpty{
            return
        }
        let position = positions.first!
        
        let rect = SKShapeNode(rect: CGRect(x: frame.midX , y: frame.midY, width: 1024, height: 1024))
        rect.fillColor = position.1 ? .green : .black
        
        
        rect.position = CGPoint(x:position.0.x * 1024, y: position.0.y * 1024)
        print(position.0)
        //rect.setScale(1/75)
        self.addChild(rect)
        
        printMap(positions: [(CGPoint, Bool)](positions.dropFirst()))
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

