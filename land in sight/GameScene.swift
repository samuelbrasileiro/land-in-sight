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
    
    var trunks: [SKSpriteNode] = []
    
    //var landBackground:SKTileMapNode!
    
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
        landBackground.setScale(1/75)

        
//        let map = SKNode()
//        addChild(map)
//        map.xScale = 1/75
//        map.yScale = 1/75
//        let tileSet = SKTileSet(named: "Tile Set")!
//        let tileSize = CGSize(width: 1024, height: 1024)
//        let columns = 64
//        let rows = 32
//
//        let deepWaterTiles = tileSet.tileGroups.first { $0.name == "Deep Water" }
//        let shallowWaterTiles = tileSet.tileGroups.first { $0.name == "Shallow Water"}
//        let sandTiles = tileSet.tileGroups.first { $0.name == "Sand"}
//
//        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
//        bottomLayer.fill(with: shallowWaterTiles)
//        map.addChild(bottomLayer)
//
//        // create the noise map
//        let noiseMap = makeNoiseMap(columns: columns, rows: rows)
//
//        // create our grass/water layer
//        let topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
//
//        // make SpriteKit do the work of placing specific tiles
//        topLayer.enableAutomapping = true
//
//        // add the grass/water layer to our main map node
//        map.addChild(topLayer)
//
//        for column in 0 ..< columns {
//            for row in 0 ..< rows {
//                let location = vector2(Int32(row), Int32(column))
//                let terrainHeight = noiseMap.value(at: location)
//                if row % 10 == 0{
//
////                    let coconut = SKSpriteNode(imageNamed: "coconut_tree")
////                    coconut.setScale(1/75)
////                    coconut.position.x += CGFloat(location.x)
////                    addChild(coconut)
//                }
//                if terrainHeight < 0 {
//                    topLayer.setTileGroup(sandTiles, forColumn: column, row: row)
//                } else {
//                    topLayer.setTileGroup(deepWaterTiles, forColumn: column, row: row)
//                }
//            }
//        }
        
    }
    func makeNoiseMap(columns: Int, rows: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.9

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
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

