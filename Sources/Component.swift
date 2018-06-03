import SourceryRuntime

struct Component {
    let implementationName: String
    let interfaceName: String
    let members: [Member]
    let variables: [Variable]

    init(_ type: Type) throws {
        implementationName = "Stiletto\(type.name)"
        interfaceName = type.name
        variables = type.variables

        // TODO: Performance
        // TODO: Cycle detection
        members = try Component.allDependencies(for: type.variables)
            .sorted(by: Component.dependencyTreeOrdering)
            .map(Member.init)
    }

    static func allDependencies(for variables: [Typed]) throws -> [Type] {
        let types: [Type] = try variables
            .map { if let type = $0.type { return type } else { throw Member.Error.missingType($0) } }
        return try allDependencies(for: types)
    }

    static func allDependencies(for types: [Type]) throws -> [Type] {
        return try types
            .map(Factory.init)
            .flatMap { $0.members }
            .map { [$0.type] }
            .map(allDependencies)
            .reduce(types, +)
            .reduce([], Utils.appendIfNew)
    }

    static func dependencyTreeOrdering(_ type1: Type, _ type2: Type) throws -> Bool {
        return try allDependencies(for: [type2]).contains(type1)
    }
}
