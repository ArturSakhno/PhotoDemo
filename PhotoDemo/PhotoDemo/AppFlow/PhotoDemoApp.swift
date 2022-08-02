//
//  PhotoDemoApp.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import SwiftUI

@main
struct PhotoDemoApp: App {
    @StateObject var appState = AppState()

    init() {
        registerDependencies()
    }

    var body: some Scene {
        WindowGroup {
            UserAuthorization()
                .environmentObject(appState)
        }
    }

    private func registerDependencies() {
        DIContainer.shared.register(type: UserServiceInterface.self, component: UserService())
        DIContainer.shared.register(type: NetworkInterface.self, component: Network())
        DIContainer.shared.register(type: UploadServiceInterface.self, component: UploadService())
    }
}
