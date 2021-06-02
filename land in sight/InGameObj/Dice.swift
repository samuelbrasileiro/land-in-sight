//
//  dice.swift
//  land in sight
//
//  Created by Luis Pereira on 02/06/21.
//

import Foundation
import SpriteKit

class Dice: SKSpriteNode{
    
    func initDice(){
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "Dice \(Int.random(in: 1...6))"), resize: true)
        self.position = CGPoint(x: 2048,y: -5*2048)
        self.run(setTexture, completion: {self.rollDice()})
    }
    
    func rollDice(){
        var actionSeq:[SKAction] = []
        for _ in 0...15{
            let setTexture = SKAction.setTexture(SKTexture(imageNamed: "Dice \(Int.random(in: 1...6))"), resize: true)
            let wait = SKAction.wait(forDuration: 0.5)
            actionSeq.append(setTexture)
            actionSeq.append(wait)
        }
        let seq = SKAction.sequence(actionSeq)
        self.run(seq)
    }
}
