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

protocol GameEnvDelegate{
    func startPlayerMovement(index:Int,houses:Int, completion: @escaping ()->Void)
}

class GameEnvironment: ObservableObject{
    var players: [Player] = []
    @Published var currentPlayer = 0
    @Published var dice = 0
    
    var delegate: GameEnvDelegate?
    
    @Published var turn: TurnPhase = .waitingToDice{
        didSet{
            switch turn {
            case .waitingToDice:
                print("bb")
            case .throwingDice:
                print("aa")
            case .walking:
                self.delegate?.startPlayerMovement(index: currentPlayer, houses: dice, completion: { [self] in
                    if currentPlayer + 1 == players.count{
                        currentPlayer = 0
                    }
                    else{
                        currentPlayer += 1
                    }
                    
                    turn = .waitingToDice
                })
            default:
                print(oldValue)
            }
        }
    }
    
    func setDice(){
        dice = (1...6).randomElement()!
    }
    
    init(){
        
    }
}
