import SourceryRuntime

func allTypes(in component: Type) -> [Type] {
    let sequence = component.variables
        .compactMap { $0.type }
        .reduce([]) { $0 + [$1] + dependencies(of: $1) }
        .reduce([String: Type]()) { var d = $0; d[$1.name] = $1; return d }
        .values
        .sorted { dependencies(of: $1).map { $0.name }.contains($0.name) }
    return Array(sequence)
}

func dependencies(of type: Type) -> [Type] {
    let initTypes = type.methods.filter { $0.annotations.keys.contains("Inject") } .first?.parameters ?? []
    let propertyTypes = type.variables.filter { $0.annotations.keys.contains("Inject") }
    let allTypes = (initTypes.compactMap { $0.type } + propertyTypes.compactMap { $0.type })
        .reduce([String: Type]()) { var d = $0; d[$1.name] = $1; return d }
        .values
    return Array(allTypes)
}

func providerImplementationName(_ type: Type) -> String {
    return "\(type.name)$$Factory"
}

func defineProvider(for type: Type) {
    print("private final class \(providerImplementationName(type)): Provider<\(type.name)> {")
    let depTypes = dependencies(of: type)
    for dependency in depTypes {
        print("    private let \(providerPropertyName(dependency.name)): Provider<\(dependency.name)>")
    }
    print("")
    print("    \(depTypes.isEmpty ? "override " : "")init(" + depTypes.map { "\(providerPropertyName($0.name)): Provider<\($0.name)>" } .joined(separator: ", ") + ") {")
    for dependency in depTypes {
        print("        self.\(providerPropertyName(dependency.name)) = \(providerPropertyName(dependency.name))")
    }
    print("    }")
    print("")
    guard let method = type.methods.filter({ $0.annotations.keys.contains("Inject") }).first else { return }
    print("    override var instance: \(type.name) {")
    print("        let instance = \(type.name)(" + method.parameters.map { "\($0.name): \(providerPropertyName($0.typeName.name)).instance" } .joined(separator: ", ") + ")")
    for variable in type.variables.filter({ $0.annotations.keys.contains("Inject") }) {
        print("        instance.\(variable.name) = \(providerPropertyName(variable.typeName.name)).instance")
    }
    print("        return instance")
    print("    }")
    print("}")
    print("")
}

func defineHeader(for component: Type) {
    print("struct Stiletto\(component.name): \(component.name) {")
    for type in allTypes(in: component) {
        print("    private let \(providerPropertyName(type.name)): Provider<\(type.name)>")
    }
    print("")
}

func providerPropertyName(_ typeName: String) -> String {
    return (typeName.prefix(1).lowercased() + typeName.dropFirst() + "Provider")
        .replacingOccurrences(of: "!", with: "")
}

func defineFooter(for component: Type) {
    print("}")
    print("")
}

func definePublicInterface(for component: Type) {
    for variable in component.variables {
        print("    var \(variable.name): \(variable.typeName) { return \(providerPropertyName(variable.typeName.name)).instance }")
    }
    print("")
}

func defineInitializer(for component: Type) {
    print("    init() {")
    for type in allTypes(in: component) {
        print(
            "        \(providerPropertyName(type.name)) = \(providerImplementationName(type))(" +
            dependencies(of: type).map { "\(providerPropertyName($0.name)): \(providerPropertyName($0.name))" } .joined(separator: ", ") +
            ")"
        )
    }
    print("    }")
    print("")
}

func main() {
    print("import Stiletto\n")
    
    for component in types.protocols where component.annotations.keys.contains("Component") {
        defineHeader(for: component)
        defineInitializer(for: component)
        definePublicInterface(for: component)
        defineFooter(for: component)
        allTypes(in: component).forEach(defineProvider)
    }
}