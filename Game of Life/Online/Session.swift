//
//  Session.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 07/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public struct Session: Codable {
    var idSession: String?
    var rounds: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var player1: PlayerInputInfo?
    var player2: PlayerInputInfo?
}
