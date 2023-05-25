//
//  ContentView.swift
//  hua
//
//  Created by BH on 5/23/23.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State private var authorizationStatus = PHPhotoLibrary.authorizationStatus()

    var body: some View {
        VStack {
            if authorizationStatus == .notDetermined {
                Button("Request Albums Access") {
                    PHPhotoLibrary.requestAuthorization { status in
                        DispatchQueue.main.async {
                            authorizationStatus = status
                        }
                    }
                }
            } else if authorizationStatus == .authorized {
                Button("Delete empty albums") {
                    deleteEmptyAlbums()
                }
            } else {
                Text("Did not get access to the albums\nYou need to give full access to the albums")
            }
        }
        .padding()
    }

    func deleteEmptyAlbums() {
        let fetchOptions = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        userAlbums.enumerateObjects { (collection, _, _) in
            let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            if assets.count == 0 {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.deleteAssetCollections([collection] as NSFastEnumeration)
                }, completionHandler: nil)
            }
        }
    }
}
