//
//  Player.swift
//  land in sight
//
//  Created by Luis Pereira on 01/06/21.
//

import Foundation
import SpriteKit

class Player:SKSpriteNode{
    var score = 0
    var isInStop = false
    func playerInit(assetName:String, origin:CGPoint){
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: assetName), resize: true)
        self.position = origin
        self.setScale(0.7)
        self.run(setTexture)
    }
    
    
    
    func movePlayer(path:[CGPoint]?){
        var actionSeqArr:[SKAction] = []
        if let validPah = path{
            for point in validPah{
                let action = SKAction.move(to: point, duration: 2)
                actionSeqArr.append(action)
            }
            let actionSeq = SKAction.sequence(actionSeqArr)
            self.run(actionSeq)
        }
    }

    
}
