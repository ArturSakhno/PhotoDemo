//
//  CameraViewModel.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import Foundation
import AVFoundation
import SwiftUI

final class CameraViewModel: NSObject, ObservableObject {
    @Published var image: UIImage?
    @Published var isSessionLoaded = false
    @Published var showAlert = false

    private var session: AVCaptureSession?
    private var output: AVCapturePhotoOutput?
    private var input: AVCaptureDeviceInput?

    var previewLayer: AVCaptureVideoPreviewLayer?

    @MainActor
    func checkCameraPermission() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {  [weak self] granted in
                Task {
                    await self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            showAlert = true
        case .authorized:
            Task {
                await setupCamera()
            }
        @unknown default:
            break
        }
    }

    func setupCamera() async {
        let start = Date()
        let session = AVCaptureSession()

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            do {
                input = try AVCaptureDeviceInput(device: device)
                output = AVCapturePhotoOutput()
                previewLayer = AVCaptureVideoPreviewLayer()

                guard let input else { return }
                guard let output else { return }

                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                previewLayer?.videoGravity = .resizeAspectFill
                previewLayer?.session = session

                session.startRunning()
                self.session = session


                print(Date().timeIntervalSince(start))
            } catch {
                print("EROR SETUP CAMERA")
            }

            await MainActor.run {
                self.isSessionLoaded = true
            }
        }
    }

    func stopSession() {
        session?.stopRunning()
        if let output {
            session?.removeOutput(output)
        }
        if let input {
            session?.removeInput(input)
        }
        session = nil
        output = nil
        previewLayer = nil

    }

    func makePhoto() {
        let settings = AVCapturePhotoSettings()
        output?.isHighResolutionCaptureEnabled = true
        settings.isHighResolutionPhotoEnabled = true
        output?.capturePhoto(with: settings, delegate: self)
    }

    deinit {
        stopSession()
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: data) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.image = image
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    private let viewModel: CameraViewModel
    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController()

        viewModel.previewLayer?.frame = vc.view.frame

        if let preview = viewModel.previewLayer {
            vc.view.layer.addSublayer(preview)
        }

        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
