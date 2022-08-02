//
//  UploadViewModel.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 01.08.2022.
//

import Foundation
import UIKit

final class UploadViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var text = ""

    private unowned var uploadService = DIContainer.shared.resolve(type: UploadServiceInterface.self)
    private unowned var userService = DIContainer.shared.resolve(type: UserServiceInterface.self)

    @MainActor
    func uploadImage(_ image: UIImage) async {
        guard let data = image.pngData() else { return }
        let result = await uploadService.uploadData(data, userID: userService.userId)
        switch result {
        case .success(let uploadImageModel):
            text = uploadImageModel.fileUrl
        case .failure(let error):
            text = error.localizedDescription
        }
    }
}
