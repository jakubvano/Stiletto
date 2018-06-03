import SourceryRuntime

struct Member: Equatable {
    let name: String
    let typeName: String
    let type: Type

    enum Error: Swift.Error {
        case missingType
    }

    init(_ parameter: Typed) throws {
        guard let type = parameter.type else { throw Member.Error.missingType }
        self.init(type)
    }

    init(_ type: Type) {
        self.name = Member.name(for: type.name)
        self.typeName = Member.typeName(for: type.name)
        self.type = type
    }

    static func name(for typeName: String) -> String {
        return Utils.camelCased(typeName) + "Provider"
    }

    static func typeName(for typeName: String) -> String {
        return "Provider<\(typeName)>"
    }
}
