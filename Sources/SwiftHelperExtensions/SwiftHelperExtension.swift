import Foundation
import SwiftUI

public struct she {
    public init() {
    }
    
    /// translate a text from localizable strings file
    /// - Parameter keyText: key text of the text to be translated from localizable file
    /// - Parameter variables: array of strings with variable text parts to put into the translation string
    /// - Returns: translated text
    public static func translateText(keyText: String, variables: [String]) -> String {
        let textInLanguage = NSLocalizedString("\(keyText)", comment: "")
        
        var replacedWithPlaceholders = ""
        
        switch variables.count {
        case 1:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables[0])
        case 2:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables[0],variables[1])
        case 3:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables[0],variables[1],variables[2])
        default:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables)
        }
        
        return replacedWithPlaceholders
    }


    /// translate a text from localizable strings file
    /// - Parameter keyText: key text of the text to be translated from localizable file
    /// - Returns: translated text
    public static func translateText(keyText: String) -> String {
        return NSLocalizedString("\(keyText)", comment: "")
    }
    
    /// translate a text from localizable strings file from this package localization
    /// - Parameter keyText: key text of the text to be translated from localizable file
    /// - Returns: translated text
    static func translateTextForPackage(keyText: String) -> String {
        return NSLocalizedString("\(keyText)", bundle: Bundle.module, comment: "")
    }
    
    
    public static func testLocalization() -> String {
        return she.translateTextForPackage(keyText: "Test")
    }
    
    /// converts the JSON string imported into an (array) or siwft classes/structs receiving the return value
    /// - Parameter jsonString: data to be decoded as data object
    /// - Returns: (array) of codable class/swift structure) that is defined as receiving variable
    public static func convertJSONDataToObject<T: Codable>(data: Data) -> T? {
        do {
            let encodedData = try JSONDecoder().decode(T.self, from: data)
            return encodedData
        } catch {
            print("Error decoding JSON into object of type \(T.self)")
            print(error)
            return nil
        }
    }
    
    /// converts the JSON string imported into an (array) or siwft classes/structs receiving the return value
    /// - Parameter jsonString: data to be decoded as String
    /// - Returns: (array) of codable class/swift structure) that is defined as receiving variable
    public static func convertJSONStringToObject<T: Codable>(jsonString: String) -> T? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert the JSON string to data")
            return nil
        }
        
        do {
            let encodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return encodedData
        } catch {
            print("Error decoding JSON into object of type \(T.self)")
            print(error)
            return nil
        }
    }
    
    /// Convert any Swift Codable Object into a String (single object or array of objects)
    /// - Parameter data: codable Swift class/struct (or array of those)
    /// - Returns: String of encoded data
    public static func convertObjectToJSONString<T: Codable>(data: T) -> String? {
        do {
            let encoded = try JSONEncoder().encode(data)
            return encoded
        } catch {
            print("Error encoding objects to JSON")
            print(error)
            return nil
        }
    }
    
    /// Write a file to the defined iCloud drie contaier with the provided filename
    /// - Parameters:
    ///   - containerId: container of the iCloud drive to write to
    ///   - fileName: name of the file to write
    ///   - fileContent: file content to be written (as data)
    func writeCloudFile(containerId: String, fileName: String, fileContent: Data) {
        let container = containerId
        
        let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: container)?.appendingPathComponent("Documents")
        guard let fileURL = driveURL?.appendingPathComponent(fileName) else {
            return
        }
        
        do {
            try fileContent.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Read a file from iCloud drive - if file is in the cloud, the download is done
    /// - Parameters:
    ///   - containerId: iCloud Drive containerId
    ///   - fileName: name of the file to be read
    /// - Returns: String with the file content or nil of file not found
    static func readCloudFile(containerId: String, fileName: String) -> String? {
        let container = containerId
        let fileManager = FileManager.default
        
        let driveURL = fileManager.url(forUbiquityContainerIdentifier: container)?.appendingPathComponent("Documents")
        if let icloudFolderURL = driveURL {
            if let urls = try? fileManager.contentsOfDirectory(at: icloudFolderURL, includingPropertiesForKeys: nil, options: []) {
                for curFileUrl in urls {
                    if (curFileUrl.lastPathComponent.contains(fileName)) {
                        var lastPathComponent = curFileUrl.lastPathComponent
                        if lastPathComponent.contains(".icloud") {
                            var downloadedFilePath = ""
                            DispatchQueue.background(background: {
                                // do something in background
                                do {
                                    try fileManager.startDownloadingUbiquitousItem(at: curFileUrl )
                                } catch {
                                    print("Unexpected error: \(error).")
                                }
                                // Delete the "." which is at the beginning of the file name
                                lastPathComponent.removeFirst()
                                let folderPath = curFileUrl.deletingLastPathComponent().path
                                downloadedFilePath = folderPath + "/" + lastPathComponent.replacingOccurrences(of: ".icloud", with: "")
                                var isDownloaded = false
                                while !isDownloaded {
                                    if fileManager.fileExists(atPath: downloadedFilePath) {
                                        isDownloaded = true
                                    }
                                }
                            }, completion:{
                                // when background job finished, do something in main thread
                                // Do what you want with your downloaded file at path contains in variable "downloadedFilePath"
                                let fileUrlLocal = URL(filePath: downloadedFilePath)
                                do {
                                    let fileContent = try String(contentsOf: fileUrlLocal, encoding: .utf8)
                                    return fileContent
                                } catch {
                                    print(error.localizedDescription)
                                    return nil
                                }
                            })
                        } else {
                            do {
                                let fileContent = try String(contentsOf: curFileUrl, encoding: .utf8)
                                return fileContent
                            } catch {
                                print(error.localizedDescription)
                                return nil
                            }
                        }
                    }
                }
            }
        } else {
            print("iCloud not available")
            return nil
        }
    }
}


