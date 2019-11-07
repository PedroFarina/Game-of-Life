//
//  GenericRequest.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 07/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

public struct ServerAnswer<T:Codable>: Codable {
    var success: Bool?
    var msg: String?
    var content: T?
}
