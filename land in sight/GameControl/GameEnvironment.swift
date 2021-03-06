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

enum MissionConsequence{
    case move(houses: Int)
    case stop
}

protocol GameEnvDelegate{
    func startPlayerMovement(index:Int,houses:Int, completion: @escaping ()->Void)
}

class Mission{
    var text: String
    var action: String
    var consequence: MissionConsequence
    
    init(text: String, action: String, consequence: MissionConsequence){
        self.text = text
        self.action = action
        self.consequence = consequence
    }
    
}

class GameEnvironment: ObservableObject{
    var players: [Player] = []
    @Published var currentPlayer = 0
    @Published var dice = 0
    
    var delegate: GameEnvDelegate?
    
    var missions: [Mission] = []
    
    @Published var currentMission = Mission(text: "", action: "", consequence: .move(houses: 0))
    
    @Published var turn: TurnPhase = .waitingToDice{
        didSet{
            switch turn {
            case .waitingToDice:
                print("adobe")
            case .throwingDice:
                
                var isSet = false
                
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){ timer in
                    self.setDice()
                    if isSet{
                        return
                    }
                    isSet = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                        timer.invalidate()
                        self.turn = .acceptingDice
                    }
                    
                }
            case .acceptingDice:
                self.setDice()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.turn = .walking
                }
            case .walking:
                
                self.delegate?.startPlayerMovement(index: currentPlayer, houses: dice, completion: { [self] in
                    
                    turn = .mission
                    
                    
                })
            case .mission:
                print("inMission")
                currentMission = missions.randomElement()!
                
            case .consequence:
                switch currentMission.consequence{
                    case .stop:
                        players[currentPlayer].isInStop = true
                        setNewTurn()
                        turn = .waitingToDice
                case let .move(houses):
                    self.delegate?.startPlayerMovement(index: currentPlayer, houses: houses, completion: { [self] in
                        setNewTurn()
                        turn = .waitingToDice
                        
                    })
                }


            }
        }
    }
    
    func setNewTurn(){
        if currentPlayer + 1 == players.count{
            currentPlayer = 0
        }
        else{
            currentPlayer += 1
        }
        if players[currentPlayer].isInStop{
            players[currentPlayer].isInStop = false
            setNewTurn()
        }
    }
    
    
    func setDice(){
        dice = (1...6).randomElement()!
    }
    
    init(){
        turn = .waitingToDice
        
        missions.append(Mission(text: "Achou uma caixa de bebidas no Mar e seus marinheiros ficaram muito felizes!", action: "Avance duas casas!", consequence: .move(houses: 2)))
        missions.append(Mission(text: "Encontrou uma b??ssola.", action: "Avance tr??s casas", consequence: .move(houses: 3)))
        missions.append(Mission(text: "Uma sereia aparece no caminho e voc?? perde  alguns tripulantes que ficam encantados.", action: "Volte duas casas.", consequence: .move(houses: -2)))
        missions.append(Mission(text: "Navio encalhado!", action: "Fique sem jogar por um turno enquanto os marinheiros fazem o reparo.", consequence: .stop))
        missions.append(Mission(text: "O navio bateu em uma pedra e voce perde parte dos recursos para consertar.", action: "Volte duas casas.", consequence: .move(houses: -2)))
        missions.append(Mission(text: "Voc?? encontra um naufrago. Ao ajudar ele, ele se diz filho de um grande lorde! Voc?? ganha muito dinheiro para melhorar seu barco.", action: "Avance tr??s casas.", consequence: .move(houses: 4)))
        missions.append(Mission(text: "Voc?? encontra uma ilha e ela esta tendo uma festa. Va aproveitar.", action: "Perca a rodada.", consequence: .stop))
        missions.append(Mission(text: "Voce entra em um cemiterio e esta com muito medo. Mas para sua surpresa, voce encontra varias moedas!", action: "Avance duas casas.", consequence: .move(houses: 2)))
        missions.append(Mission(text: "Sua bussola quebrou e agora voc??s tem que consertar ela.", action: "Fique um turno trabalhando nesse reparo.", consequence: .stop))
        missions.append(Mission(text: "Devido a viagem exaustiva os marinheiros acabam ficando enjoados.", action: "Volte uma casa", consequence: .move(houses: -1)))
        missions.append(Mission(text: "O povo nativo rejeitou seu navio e voc?? teve que se distanciar.", action: "Volte tr??s casas", consequence: .move(houses: -3)))
    }
}
