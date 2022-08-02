//
//  UploadView.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 01.08.2022.
//

import SwiftUI

struct UploadView: View {
    @Namespace var animation

    @EnvironmentObject var state: AppState

    @StateObject var viewModel = UploadViewModel()

    var image: UIImage


    var body: some View {
        VStack {
            if !viewModel.text.isEmpty {
                Text(viewModel.text)
                    .contextMenu {
                        Button("Copy URL") {
                            UIPasteboard.general.string = viewModel.text
                        }
                    }
            }

            Button {
                Task {
                    withAnimation { viewModel.isLoading.toggle() }
                    await viewModel.uploadImage(image)
                    withAnimation { viewModel.isLoading.toggle() }
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    state.moveToRoot = true
                }
            } label: {
                if viewModel.isLoading {
                    loadingButton.anyView
                } else {
                    upploadButton.anyView
                }
            }
            .disabled(viewModel.isLoading)
        }

    }

    var loadingButton: some View {
        ZStack {
            Circle()
                .frame(width: 44, height: 44)
                .foregroundColor(.yellow)
            ProgressView()
                .progressViewStyle(.circular)
                .foregroundColor(.white)
        }
        .matchedGeometryEffect(id: "Loading", in: animation)

    }
    var upploadButton: some View {
        ZStack {
            Color.blue
                .matchedGeometryEffect(id: "Loading", in: animation)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)

            Text("UPLOAD")
                .foregroundColor(.white)
        }

    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(image: UIImage())
    }
}
