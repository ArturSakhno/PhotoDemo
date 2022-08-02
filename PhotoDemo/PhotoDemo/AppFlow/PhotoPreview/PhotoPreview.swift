//
//  PhotoPreview.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 01.08.2022.
//

import SwiftUI

struct PhotoPreview: View {
    let image: UIImage
    var onRetakeTap: (() -> ())?

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable().scaledToFit()

            VStack {
                Spacer()
                HStack {
                    Button("Retake") {
                        onRetakeTap?()
                    }
                    Spacer()
                    NavigationLink("Continue") {
                        UploadView(image: image)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
    }
}

struct PhotoPreview_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPreview(image: UIImage())
    }
}
