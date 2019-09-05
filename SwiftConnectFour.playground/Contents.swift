// Challenge 20 - Connect Four

import UIKit

class TopList {
    
    @objc var appId: String?
    
    init(appId: String) {
        self.appId = appId
    }
}

let keyPath3 = #keyPath(TopList.appId)

enum BoardSpace {
    case Empty, PlayerOneToken, PlayerTwoToken
    
    func getBoardCharacter() -> String {
        switch self {
        case .Empty:
            return "0"
        case .PlayerOneToken:
            return "1"
        case .PlayerTwoToken:
            return "2"
        }
    }
}

var gameFinished = false

var playerOneTurn = true

var playerOneVictory : Bool? = nil

let rows = 6
let columns = 7

var gameBoard = [[BoardSpace]](repeating: [BoardSpace](repeating: BoardSpace.Empty, count: columns), count: rows)

func checkForWinConditionAfterPlayerTurn(player: Int) {
    
    let checkedTokenType = player == 0 ? BoardSpace.PlayerOneToken : BoardSpace.PlayerTwoToken
    
    // check if player has won
    for i in 0..<gameBoard.count {
        for j in 0..<gameBoard[i].count {
            
            if gameBoard[i][j] == checkedTokenType {
                
                // check if in a matching set
                for x in i-1...i+1 {
                    for y in j-1...j+1 {
                        
                        if (x != i || y != j) &&
                        x >= 0 && y >= 0 &&
                        x < gameBoard.count && y < gameBoard[i].count {
                            
                            let direction = (vx: x - i, vy: y - j)
                            
                            if (direction.vx != 0 || direction.vy != 0) &&
                                x + direction.vx * 3 >= 0 && x + direction.vx * 3 < gameBoard.count &&
                                y + direction.vy * 3 >= 0 && y + direction.vy * 3 < gameBoard[x].count
                            {
                                
                                var nextSpace : BoardSpace = gameBoard[x][y]
                                
                                var matchCount = 1
                                
                                var nextSpaceX = x
                                var nextSpaceY = y
                            
                                while nextSpace == checkedTokenType && matchCount < 4 {
                                    
                                    matchCount += 1
                                    
                                    nextSpaceX = nextSpaceX + direction.vx
                                    nextSpaceY = nextSpaceY + direction.vy
                                    
                                    if nextSpaceX >= 0 && nextSpaceY >= 0
                                        && nextSpaceX < gameBoard.count
                                        && nextSpaceY < gameBoard[nextSpaceX].count &&
                                        (nextSpaceX != x || nextSpaceY != y)
                                    {
                                        
                                        nextSpace = gameBoard[nextSpaceX][nextSpaceY]
                                    }
                                    else {
                                        nextSpace = BoardSpace.Empty
                                    }
                                }
                                
                                if matchCount == 4 {
                                    gameFinished = true
                                    playerOneVictory = player == 0 ? true : false
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // check if tie game
    if !gameFinished {
        
        var tieGame = true
        
        for i in 0..<gameBoard[0].count {
            
            if gameBoard[0][i] == BoardSpace.Empty { tieGame = false }
        }
        
        if tieGame { gameFinished = true }
    }
}

func getGameBoardPrintout() -> String {
    
    var gameBoardPrintable = String()
    
    for i in 0..<gameBoard.count {
        for j in 0..<gameBoard[i].count {
            gameBoardPrintable += gameBoard[i][j].getBoardCharacter()
        }
        
        gameBoardPrintable += "\n"
    }
    
    return gameBoardPrintable
}

while !gameFinished {
    
    var randomColumn = -1
    
    while randomColumn < 0 {
        
        randomColumn = Int(arc4random_uniform(UInt32(columns)))
        
        if gameBoard[0][randomColumn] != BoardSpace.Empty {
            randomColumn = -1
        }
    }
    
    // place piece
    for i in (0..<gameBoard.count).reversed() {
        
        if gameBoard[i][randomColumn] == BoardSpace.Empty {
            gameBoard[i][randomColumn] = playerOneTurn ? BoardSpace.PlayerOneToken : BoardSpace.PlayerTwoToken
            break
        }
    }
    
    // check for victory
    checkForWinConditionAfterPlayerTurn(player: (playerOneTurn ? 0 : 1))
    
    // change turn
    playerOneTurn = !playerOneTurn
}

if gameFinished {
    
    if let playerOneWins = playerOneVictory {
        
        print("Player " + (playerOneWins ? "One" : "Two") + " wins!")
    }
    else {
        print("Tie game!")
    }
}

print(getGameBoardPrintout())
