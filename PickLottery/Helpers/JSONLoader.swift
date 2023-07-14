import Foundation

enum JSONLoader {
    static func load<T: Decodable>(
        fileName: String,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Unable to locate file \"\(fileName)\" in main bundle.")
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {
            fatalError("Unable to load \"\(fileName)\" from main bundle:\n\(error)")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Unable to decode \"\(data)\" as \(T.self):\n\(error)")
        }
    }
}
