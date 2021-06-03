//
//  GameLoader.swift
//  land in sight
//
//  Created by Luis Pereira on 03/06/21.
//

import Foundation

class GameSceneLoader: ObservableObject{
    @Published var scene: GameScene = GameScene()
//    public init(){
//
//    }
    
    init(){
        
    }
    init(environment: GameEnvironment){
        reset(environment)
    }
    
    public func reset(_ environment: GameEnvironment){
        guard let scene = GameScene(fileNamed: "MyScene.sks") else{
            fatalError("Did not load scene")
        }
        //let scene = GameScene(size: CGSize(width: 800, height: 500))
        scene.env = environment
        //scene.environment = environment
        scene.scaleMode = .aspectFill
        self.scene = scene
    }
    
}
