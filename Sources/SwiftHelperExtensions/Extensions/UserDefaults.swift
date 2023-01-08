import Foundation

//TODO move error text to localization strings

public enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    public var errorDescription: String? {
        she.translateTextForPackage(keyText: StringrawValue)
    }
}

public extension UserDefaults {
    /// save a object to UserDefaults
    /// - Parameters:
    ///   - object: object to be saved to UserDefaults
    ///   - forKey: key to save the object to
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    /// read an object from UserDefaults
    /// - Parameters:
    ///   - forKey: key to be read
    ///   - type: type of the object to read
    /// - Returns: saved object
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

//
//  NSUbiquitousKeyValueStore
//
//  Similar Extension for Cloud Key Value Storage like UserDefaults
//

public extension NSUbiquitousKeyValueStore {
    /// save a object to iCloud KeyStore
    /// - Parameters:
    ///   - object: object to be saved to iCloud KeyStore
    ///   - forKey: key to save the object to
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    /// read an object from iCloud KeyStore
    /// - Parameters:
    ///   - forKey: key to be read
    ///   - type: type of the object to read
    /// - Returns: saved object
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
