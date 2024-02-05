//
//  CachedImageView.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import SwiftUI
import Kingfisher

struct CachedImageView: View {
    let imageUrl: URL?

    var body: some View {
        KFImage(imageUrl)
            .resizable()
            .placeholder {
                // Placeholder while image is being loaded
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            .onFailure { error in
                // Handle failure, e.g., display a placeholder or show an error message
                print("Image download failed: \(error)")
            }

            .cancelOnDisappear(true)
            .aspectRatio(contentMode: .fit)
    }
}
