//
//  UserAuthorization.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import SwiftUI

struct UserAuthorization: View {
    @StateObject private var viewModel = UserAuthorizationViewModel()

    @EnvironmentObject var appState: AppState
    @State var nextScreen = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Id", text: $viewModel.input)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: viewModel.input) { _ in
                        viewModel.onInputChange()
                    }

                NavigationLink(destination: CameraView(), isActive: $nextScreen) { }

                Button {
                    nextScreen = true
                } label: {
                    Text("Submit")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(viewModel.isSubmitDisabled ? Color.gray : Color.blue)
                        .padding(.horizontal)
                }
                .disabled(viewModel.isSubmitDisabled)
            }
        }
        .onReceive(appState.$moveToRoot, perform: { moveToRoot in
            if moveToRoot {
                nextScreen = false
                appState.moveToRoot = false
                viewModel.input = ""
            }
        })
        .hideKeyboard()

    }
}

struct UserAuthorization_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthorization()
    }
}
