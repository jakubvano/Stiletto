import SourceryRuntime

struct Member {
    let name: String
    let typeName: String

    init(_ parameter: MethodParameter) {
        self.name = Member.name(for: parameter.typeName.name)
        self.typeName = "Provider<\(parameter.typeName)>"
    }

    static func name(for typeName: String) -> String {
        return Utils.camelCased(typeName) + "Provider"
    }
}
