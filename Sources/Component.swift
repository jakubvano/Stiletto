import SourceryRuntime

struct Component {
    let implementationName: String
    let interfaceName: String
    let members: [Member]

    init(_ type: Type) throws {
        implementationName = "Stiletto\(type.name)"
        interfaceName = type.name
        members = try type.variables.map(Member.init)
    }
}
