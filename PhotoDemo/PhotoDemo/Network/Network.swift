//
//  Network.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 01.08.2022.
//

import Foundation

protocol NetworkInterface: AnyObject {
    func upload<T: Decodable>(data: Data, request: URLRequest, responseModel: T.Type) async -> Result<T, RequestError>
}

public final class Network: NetworkInterface {
    func upload<T: Decodable>(data: Data, request: URLRequest, responseModel: T.Type) async -> Result<T, RequestError> {
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: data)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                    return .success(decodedResponse)
                } catch {
                    return .failure(.decode)
                }
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unexpectedStatusCode
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .unexpectedStatusCode:
            return "Unexpected Status Code"
        default:
            return "Unknown error"
        }
    }
}
