import Foundation

public class FileService {
    public init() {}
    
    public func findSwiftFiles(in path: String) -> Set<String> {
        var swiftFiles: Set<String> = []
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: path)
            if let fileType = attribute[.type] as? FileAttributeType {
                switch fileType {
                case .typeDirectory:
                    let dirPath = path.ensureTrailingSlash()
                    let enumerator = FileManager.default.enumerator(atPath: dirPath)
                    while let relativePath = enumerator?.nextObject() as? String {
                        let filePath = dirPath + relativePath
                        if URL(fileURLWithPath: filePath).pathExtension == "swift" {
                            swiftFiles.insert(filePath)
                        }
                    }
                case .typeRegular:
                    if URL(fileURLWithPath: path).pathExtension == "swift" {
                        swiftFiles.insert(path)
                    }
                default:
                    break
                }
            }
        } catch {
            print("⛔️Error:", error)
        }
        return swiftFiles
    }

    public func write(source: String, at path: String) throws {
        try source.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
}
