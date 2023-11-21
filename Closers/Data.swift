//
//  Data.swift
//  Closers
//
//  Created by Chen, Yanshi on 11/15/23.
//

import Foundation
import SpriteKit

class Data: ObservableObject {
    static let shared = Data()
    var rounds: Int = 0
    var numPlayers: Int = 0
    var drawings: [[SKShapeNode]] = []
    var prompts: [String] = []
  
}
