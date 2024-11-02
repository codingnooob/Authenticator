import Foundation

// Example definition of PersistentToken
struct PersistentToken {
    // Assuming these properties exist; customize them per your actual use case
    var identifier: Data
    var token: Token

    // Example nested Token struct definition; customize as needed
    struct Token: Codable {
        var value: String
    }
}

// Example KeyValuePair struct definition; customize this too
struct KeyValuePair: Codable {
    var identifier: Data
    var tokenData: Data

    static func from(_ identifier: Data, _ tokenData: Data) -> KeyValuePair {
        return KeyValuePair(identifier: identifier, tokenData: tokenData)
    }
}

// Define a simple custom Error
enum CustomError: Error {
    case runtimeError(String)
}

// Main function to execute program logic
func main() {
    do {
        try performTask()
    } catch let error as CustomError {
        print("Caught a custom error: \(error)")
    } catch {
        print("An unexpected error: \(error)")
    }
}

// A sample function to demonstrate throwing an error
func performTask() throws {
    // Simulating an error condition
    throw CustomError.runtimeError("This is a runtime error")
}

struct ExportService {
   static func export(tokens: [PersistentToken]) -> String {
       let jsonTokens = tokens.map {
           TokenSerializer.toJSON($0)
       }
        guard let jsonString = String(data: try! JSONSerialization.data(withJSONObject: jsonTokens, options: []), encoding: .utf8) else {
        return ""
}
        return jsonString
}
}

struct TokenSerializer {
   static func toJSON(_ token: PersistentToken) -> Data {
        guard let identifierData = token.identifier.base64EncodedString(options: []).data(using: .utf8),
             let tokenData = try? JSONEncoder().encode(token.token),
              let keychainData = try? JSONEncoder().encode(KeyValuePair.from(identifierData, tokenData)) else {
           return Data()
       }
       return keychainData
   }
}

// Execute the main function
main()
