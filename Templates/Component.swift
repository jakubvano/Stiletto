import SourceryRuntime

func constructor(for type: Type) -> String {
    guard let method = type.methods.filter({ $0.annotations.keys.contains("Inject") }).first else { return "/* No constructor available */" }
    return type.name + "("
        + method.parameters.map { "\($0.name): make\($0.typeName)()" } .joined(separator: ", ")
        + ")"
}

func dependencyTypes(for type: Type) -> [Type] {
    let initParams = type.methods.filter { $0.annotations.keys.contains("Inject") } .first?.parameters ?? []
    return [type] + initParams.compactMap { $0.type }
}

func main() {
    for component in types.protocols where component.annotations.keys.contains("Component") {
        let implementationName = "Stiletto" + component.name
        print("struct \(implementationName): \(component.name) {")
        print("    static func create() -> \(component.name) {")
        print("        return \(implementationName)()")
        print("    }")
        print("")

        for variable in component.variables {
            print("    var \(variable.name): \(variable.typeName) { return make\(variable.typeName )() }")
        }
        print("")

        let types = component.variables
            .compactMap { $0.type }
            .reduce([]) { $0 + dependencyTypes(for: $1) }
            .reduce([String: Type]()) { var d = $0; d[$1.name] = $1; return d }
            .values

        for type in types {
            print("    private func make\(type.name)() -> \(type.name) {")
            print("        return \(constructor(for: type))")
            print("     }")
        }
        print("")

        print("}")
    }
}
