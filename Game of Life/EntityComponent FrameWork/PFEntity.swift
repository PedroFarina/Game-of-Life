//
//  PFEntity.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class PFEntity: NSObject {
    weak var node: PFNode?
    private var components: Set<PFComponent> = []

    public func addComponent<T: PFComponent>(_ component: T) {
        components.insert(component)
    }

    public func removeComponent<T: PFComponent>(_ component: T) {
        components.remove(component)
    }

    public func component<T: PFComponent>(ofType cType: T.Type) -> T? {
        guard let component = components.first(where: { (comp) -> Bool in
            return type(of: comp) == cType
        }) as? T else {
            return nil
        }
        return component
    }

    public func update(deltaTime seconds: TimeInterval) {
        for component in components {
            component.update(deltaTime: seconds)
        }
    }
}
