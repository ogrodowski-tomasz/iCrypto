//
//  LocalFileManager.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 25/04/2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    // Creating singleton for using this class for entire app
    static let instance = LocalFileManager()
    private init() { } // not letting init this class outside of this class

    func saveImage(image: UIImage, folderName: String, imageName: String) {
        /// Create folder if it doesn't already exist
        createFolderIfNeeded(folderName: folderName)

        /// We cannot save an UIImage into FileManager, but we can save data of this image.
        /// In order to do that, we have to convert this image into data
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }

        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image \(imageName) to FileManager: \(error.localizedDescription)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }

    /// Creating folder with given name into specific directory
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) { // if this folder doesn't exist - create it
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating director. FolderName: \(folderName). \(error.localizedDescription)")
            }
        }
    }

    // we only gonna access this func within this class
    /// getting url for given folder
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }

    /// given an url for specific image in specific folder created by app
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
