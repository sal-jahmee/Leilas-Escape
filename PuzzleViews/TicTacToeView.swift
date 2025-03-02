//
//  ContentView.swift
//  Game
//
//  Created by Saeed Mohamed on 2/12/25.
//


import Foundation
import SwiftUI

// Enum for the tiles (Noughts and Crosses)
enum Tile {
    case Nought
    case Cross
    case Empty
}

// Cell structure representing each tile in the grid
struct Cell {
    var tile: Tile
    
    func displayTile() -> String {
        switch tile {
        case .Nought:
            return "🟢"
        case .Cross:
            return "❌"
        default:
            return ""
        }
    }
    
    func tileColor() -> Color {
        switch tile {
        case .Nought:
            return Color.red
        case .Cross:
            return Color.black
        default:
            return Color.black
        }
    }
}

// The main game state observable class
class GameState: ObservableObject {
    @Published var board: [[Cell]]
    @Published var turn: Tile
    @Published var noughtsScore: Int
    @Published var crossesScore: Int
    @Published var showAlert: Bool
    @Published var alertMessage: String
    
    init() {
        self.board = Array(repeating: Array(repeating: Cell(tile: .Empty), count: 3), count: 3)
        self.turn = .Cross  // Player is Cross
        self.noughtsScore = 0
        self.crossesScore = 0
        self.showAlert = false
        self.alertMessage = "Draw"
    }
    
    func turnText() -> String {
        return turn == .Cross ? "Princess Turn(X)" : "Skeleton's Turn (O)"
    }
    
    func placeTile(_ row: Int, _ column: Int) {
        guard board[row][column].tile == .Empty else { return }
        
        // Player places their tile
        board[row][column].tile = turn
        if checkForVictory() {
            if turn == .Cross {
                crossesScore += 1
            } else {
                noughtsScore += 1
            }
            alertMessage = "\(turn == .Cross ? "You Win!" : "skeleton Wins!")"
            showAlert = true
        } else if checkForDraw() {
            alertMessage = "Draw"
            showAlert = true
        } else {
            turn = .Nought // Change turn to AI
            aiMove()
        }
    }
    
    func aiMove() {
        // AI makes a move after a short delay to simulate thinking
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // AI chooses a random empty spot on the board
            var availableMoves: [(Int, Int)] = []
            for row in 0..<3 {
                for col in 0..<3 {
                    if self.board[row][col].tile == .Empty {
                        availableMoves.append((row, col))
                    }
                }
            }
            
            // Randomly select a move
            if let move = availableMoves.randomElement() {
                self.board[move.0][move.1].tile = .Nought
                if self.checkForVictory() {
                    self.noughtsScore += 1
                    self.alertMessage = "skeleton Wins!"
                    self.showAlert = true
                } else if self.checkForDraw() {
                    self.alertMessage = "Draw"
                    self.showAlert = true
                } else {
                    self.turn = .Cross // Player's turn again
                }
            }
        }
    }
    
    func checkForDraw() -> Bool {
        return !board.flatMap { $0 }.contains { $0.tile == .Empty }
    }
    
    func checkForVictory() -> Bool {
        // Check rows, columns, and diagonals for a win
        for i in 0..<3 {
            if board[i][0].tile == turn && board[i][1].tile == turn && board[i][2].tile == turn { return true }
            if board[0][i].tile == turn && board[1][i].tile == turn && board[2][i].tile == turn { return true }
        }
        if board[0][0].tile == turn && board[1][1].tile == turn && board[2][2].tile == turn { return true }
        if board[0][2].tile == turn && board[1][1].tile == turn && board[2][0].tile == turn { return true }
        
        return false
    }
    
    func resetBoard() {
        board = Array(repeating: Array(repeating: Cell(tile: .Empty), count: 3), count: 3)
    }
}

// The main view for the game
struct TicTacToeView: View {
    @Binding var showTicTacToe: Bool
    @StateObject var gameState = GameState()
    
    var body: some View {
        VStack {
            // Current turn text
            Text(gameState.turnText())
                .font(.title)
                .bold()
                .padding()
            
            // Score display
            HStack {
                Text("Princess: \(gameState.crossesScore)")
                    .font(.title)
                    .bold()
                Spacer()
                Text("Skeleton: \(gameState.noughtsScore)")
                    .font(.title)
                    .bold()
            }
            .padding()

            // Tic-Tac-Toe grid
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { column in
                            let cell = gameState.board[row][column]
                            
                            Text(cell.displayTile())
                                .font(.system(size: 60))
                                .foregroundColor(cell.tileColor())
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(Color.white)
                                .border(Color.black, width: 2)
                                .onTapGesture {
                                    if gameState.turn == .Cross {
                                        gameState.placeTile(row, column)
                                    }
                                }
                        }
                    }
                }
            }
            .padding()
            .background(Color.black)
            .alert(isPresented: $gameState.showAlert) {
                Alert(
                    title: Text(gameState.alertMessage),
                    dismissButton: .default(Text("Okay")) {
                        gameState.resetBoard()
                    }
                )
            }

            Spacer()
        }
        .padding()
    }
}

// Preview the ContentView
struct TicTacToeView_Previews: PreviewProvider {
    static var previews: some View {
        TicTacToeView(showTicTacToe: .constant(true))
    }
}


