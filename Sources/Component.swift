import SourceryRuntime

struct Component {
    let implementationName: String
    let interfaceName: String
    let members: [Member]
    let variables: [Variable]

    init(_ type: Type) throws {
        implementationName = "Stiletto\(type.name)"
        interfaceName = type.name
        members = try allDependencies(for: type.variables).map(Member.init)
        variables = type.variables
    }
}

func allDependencies(for variables: [Typed]) throws -> [Type] {
    let types: [Type] = try variables
        .map { if let type = $0.type { return type } else { throw Member.Error.missingType } }
    return try allDependencies(for: types)
}

func allDependencies(for types: [Type]) throws -> [Type] {
    return try types
        .map(Factory.init)
        .flatMap { $0.members }
        .map { [$0.type] }
        .map(allDependencies)
        .reduce(types, +)
        .reduce([], Utils.appendIfNew)
}
