//
//  Player.swift
//  land in sight
//
//  Created by Luis Pereira on 01/06/21.
//

import Foundation
import SpriteKit

class Player:SKSpriteNode{
    
    func playerInit(assetName:String, origin:CGPoint){
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: assetName), resize: true)
        self.run(setTexture)
        self.position = origin
    }
    
}
