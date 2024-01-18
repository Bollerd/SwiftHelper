import Foundation
import SwiftUI
import Files
import ZIPFoundation

public struct she {
    public init() {
    }
    
    /*
     **************************
     * text translation functions
     **************************
     */
    
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
    
    
    /*
     **************************
     * JSON wrappers functions
     **************************
     */
    
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
            if let utf8String = String(data: encoded, encoding: .utf8) {
                return utf8String
            } else {
                return nil
            }

        } catch {
            print("Error encoding objects to JSON")
            print(error)
            return nil
        }
    }
    
    /*
     **************************
     * iCloud functions
     **************************
     */
    
    /// Write a file to the defined iCloud drie contaier with the provided filename
    /// - Parameters:
    ///   - containerId: container of the iCloud drive to write to
    ///   - fileName: name of the file to write
    ///   - fileContent: file content to be written (as data)
    public static func writeCloudFile(containerId: String, fileName: String, fileContent: Data, zip: Bool = false) {
        let container = containerId
        
        let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: container)?.appendingPathComponent("Documents")
        guard let fileURL = driveURL?.appendingPathComponent(fileName) else {
            return
        }
        
        do {
            if zip == false {
                try fileContent.write(to: fileURL)
            } else {
                guard let archive = Archive(accessMode: .create),
                      let data = fileContent else {
                    print("Zipping file failed: Did not get archive or data")
                    return
                }
            
                try? archive.addEntry(with: "inMemory.txt", type: .file, uncompressedSize: UInt32(data.count), compressionMethod: .deflate, bufferSize: 4, provider: { (position, size) -> Data in
                    return data.subdata(in: position..<position+size)
                })
                
                guard let archiveData = archive.data else {
                    print("Zipping file failed: Did not get archivedata")
                    return
                }
            
                let memoryUrl = URL.documentsDirectory.appending(path: "message.zip")
                try archiveData.write(to: memoryUrl, options: [.atomic, .completeFileProtection])
                let zippedData = try Data(contentsOf: memoryUrl)
                
                try zippedData.write(to: fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Read a file from iCloud drive - if file is in the cloud, the download is done
    /// - Parameters:
    ///   - containerId: iCloud Drive containerId
    ///   - fileName: name of the file to be read
    ///   - fileModel;  Object that implements protocol iCloudFileHelperModel - receives read file string after completion
    /// - Returns: String with the file content or nil of file not found
    
    public static func readCloudFile<T>(containerId: String, fileName: String, fileModel: T, unzip: Bool = false) where T: iCloudFileHelperModel {
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
                            DispatchQueue.background(data: fileModel, background: {
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
                                    var fileContent = ""
                                    
                                    if unzip == false {
                                        fileContent = try String(contentsOf: fileUrlLocal, encoding: .utf8)
                                    } else {
                                        let fileData = try Data(contentsOf: fileUrlLocal)
                                        fileContent = she.unzipData(zippedData: fileData)
                                    }
                                    
                                    fileModel.fileContent = fileContent
                                } catch {
                                    print(error.localizedDescription)
                                    fileModel.fileContent = ""
                                }
                            })
                        } else {
                            do {
                                var fileContent = ""
                                
                                if unzip == false {
                                    fileContent = try String(contentsOf: curFileUrl, encoding: .utf8)
                                } else {
                                    let fileData = try Data(contentsOf: curFileUrl)
                                    fileContent = she.unzipData(zippedData: fileData)
                                }
                                    
                                fileModel.fileContent = fileContent
                            } catch {
                                print(error.localizedDescription)
                                fileModel.fileContent = ""
                            }
                        }
                    }
                }
            }
        } else {
            print("iCloud not available")
        }
    }
    
    /// Unzip data and return the unzipped value as data
    /// - Parameter zippedData: data object of zipped content
    /// - Returns:unzipped value of zipped data
   static func unzipData(zippedData: Data) -> Data {
        do {
            guard let archive = Archive(data: zippedData, accessMode: .read) else {
                print("Unzipping data failed; unable to get archive")
                return Data()
            }
            guard let entry = archive["inMemory.txt"] else {
                print("Unzipping data failed; unable to get entry")
                return Data()
            }
            var returnData = Data()
            try archive.extract(entry, consumer: { (data) in
                returnData = data
            })
            return returnData
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    /// Unzip data and return the unzipped value as string
    /// - Parameter zippedData: data object of zipped content
    /// - Returns:String value of zipped data
    static func unzipData(zippedData: Data) -> String {
        do {
            guard let archive = Archive(data: zippedData, accessMode: .read) else {
                print("Unzipping data failed; unable to get archive")
                return ""
            }
            guard let entry = archive["inMemory.txt"] else {
                print("Unzipping data failed; unable to get entry")
                return ""
            }
            var returnString = ""
            try archive.extract(entry, consumer: { (data) in
                let str = String(decoding: data, as: UTF8.self)
                returnString += str
                return returnString
            })
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    /*
     **************************
     * local file functions
     **************************
     */
    
    public static func checkIfLocalFileExists(fileName: String, folderName: String = "") -> Bool {
        do {
            var slash = ""
            if folderName != "" {
                slash = "/"
            }
            _ = try File(path: Folder.documents!.path + slash + folderName + "/" + fileName).name
            return true
        }
        catch {
            print("Catch when trying to check existance of file \(fileName)")
            print(error.localizedDescription)
            return false
        }
    }
    
    public static func getLocalFileContent(fileName: String, folderName: String = "") -> Data {
        do {
            var slash = ""
            if folderName != "" {
                slash = "/"
            }
           
            return try File(path: folderName + slash + fileName).read()
        }
        catch {
            print("Catch when trying to read content of file \(fileName)")
            print(error.localizedDescription)
            return Data()
        }
    }
    
    public static func createFolderIfNeeded(rootFolder: String = Folder.documents!.path, newFolder: String) {
        do {
            try Folder(path: rootFolder).createSubfolderIfNeeded(withName: newFolder)
        }
        catch {
            print("Catch when trying to create cache directory")
            print(error.localizedDescription)
        }
    }
}


