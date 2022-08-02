//
//  UploadService.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 01.08.2022.
//

import Foundation

protocol UploadServiceInterface: AnyObject {
    func uploadData(_ data: Data, userID: String) async  -> Result<UploadImageModel, RequestError>
}

final class UploadService: UploadServiceInterface {
    private unowned var network = DIContainer.shared.resolve(type: NetworkInterface.self)

    func uploadData(_ data: Data, userID: String) async -> Result<UploadImageModel, RequestError> {
        guard let url = URL(string: "https://api.upload.io/v1/files/basic") else {  return .failure(.invalidURL) }
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue

        request.addValue("Bearer public_FW25at1FzhpuRSy7zgEp9JeNjPwB", forHTTPHeaderField: "Authorization")
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.addValue(userID, forHTTPHeaderField: "userId")
        request.addValue("timestamp", forHTTPHeaderField: "\(Date())")

        let result = await network.upload(data: data, request: request, responseModel: UploadImageModel.self)

        return result
    }
}
