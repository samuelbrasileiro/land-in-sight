//
//  GameEnvironment.swift
//  land in sight
//
//  Created by Samuel Brasileiro on 03/06/21.
//

import SwiftUI

enum TurnPhase{
    case waitingToDice
    case throwingDice
    case acceptingDice
    case walking
    case mission
    case consequence
}



class GameEnvironment: ObservableObject{
    var players: [Player] = []
    var currentPlayer = 0
    let dice = Dice()
    
    var turn: TurnPhase = .waitingToDice{
        didSet{
            switch turn {
            case .waitingToDice:
                print("bb")
            case .throwingDice:
                print("aa")
            
            default:
                print(oldValue)
            }
        }
    }
    
    init(){
        
    }
}
