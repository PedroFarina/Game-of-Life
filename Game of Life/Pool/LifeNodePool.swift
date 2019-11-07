//
//  LifePool.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 01/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class LifeNodePool {
    private init(){
    }

    public static func start(){
        _  = getLife()
    }

    private static let lockQueue = DispatchQueue.init(label: "lifeNodePool")

    private static var lifePool: Pool<MyNode> = {
        var lifes: [LifeNode] = []

        DispatchQueue.concurrentPerform(iterations: 50000) { (i) in
            lockQueue.sync {
                lifes.append(LifeNode())
            }
        }

        return Pool(lifes)
    }()

    public static func getLife() -> LifeNode {
        if let pool = lifePool.acquire() as? LifeNode {
            return pool
        } else {
            makeMore()
            return LifeNode()
        }
    }

    public static func release(_ node: MyNode) {
        lifePool.release(node)
    }

    private static var makingMore: Bool = false
    private static func makeMore() {
        if !makingMore {
            makingMore = true
            var lifes: [LifeNode] = []

            DispatchQueue.concurrentPerform(iterations: 50000) { (_) in
                lockQueue.sync {
                    lifes.append(LifeNode())
                }
            }
            lifePool.release(lifes)
            makingMore = false
        }
    }
}
