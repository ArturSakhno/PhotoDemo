//
//  Camera.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var viewModel = CameraViewModel()
    @State var nextScreen = false

    var body: some View {
        Group {
            if let image = viewModel.image {
                buildPhotoPreview(image: image)
            } else {
                cameraView
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Provide access to camera in settings"))
        }

        .onAppear {
            Task {
                await viewModel.checkCameraPermission()
            }
        }


    }

    var cameraView: some View {
        ZStack {
            if viewModel.isSessionLoaded {
                CameraViewController(viewModel: viewModel)
            }
            VStack {
                Spacer()
                Button {
                    viewModel.makePhoto()
                    nextScreen.toggle()
                } label: {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 50)
            }
        }
    }

    func buildPhotoPreview(image: UIImage) -> some View {
        PhotoPreview(image: image) {
            viewModel.image = nil
//            viewModel.stopSession()
        }
    }
}

struct Camera_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}


