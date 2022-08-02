//
//  DIContainer.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 02.08.2022.
//

import Foundation

protocol DIContainerInterface: AnyObject {
    func register<Component>(type: Component.Type, component: Any)
    func resolve<Component>(type: Component.Type) -> Component
}

final class DIContainer: DIContainerInterface {
    static let shared = DIContainer()

    var components: [String: Any] = [:]

    private init() {}

    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    func resolve<Component>(type: Component.Type) -> Component {
        return components["\(type)"] as! Component
    }
}
