import SourceryRuntime

func allTypes(in component: Type) -> [Type] {
    let sequence = component.variables
        .compactMap { $0.type }
        .reduce([]) { $0 + dependencyTypes(for: $1) }
        .reduce([String: Type]()) { var d = $0; d[$1.name] = $1; return d }
        .values
        .sorted { dependencyTypes(for: $1).map { $0.name }.contains($0.name) }
    return Array(sequence)
}

func dependencyTypes(for type: Type) -> [Type] {
    let initParams = type.methods.filter { $0.annotations.keys.contains("Inject") } .first?.parameters ?? []
    return [type] + initParams.compactMap { $0.type }
}

func providerImplementationName(_ type: Type) -> String {
    return "\(type.name)$$Factory"
}

func defineProvider(for type: Type) {
    print("private final class \(providerImplementationName(type)): Provider<\(type.name)> {")
    guard let method = type.methods.filter({ $0.annotations.keys.contains("Inject") }).first else { return }
    for parameter in method.parameters {
        print("    private let \(parameter.name)Provider: Provider<\(parameter.typeName)>")
    }
    print("")

    print("    \(method.parameters.isEmpty ? "override " : "")init(" + method.parameters.map { "\($0.name)Provider: Provider<\($0.typeName)>" } .joined(separator: ", ") + ") {")
    for parameter in method.parameters {
        print("        self.\(parameter.name)Provider = \(parameter.name)Provider")
    }
    print("    }")
    print("")
    print("    override var instance: \(type.name) {")
    print("        return \(type.name)(" + method.parameters.map { "\($0.name): \($0.name)Provider.instance" } .joined(separator: ", ") + ")")
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
    return typeName.prefix(1).lowercased() + typeName.dropFirst() + "Provider"
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
        guard let parameters = type.methods.filter({ $0.annotations.keys.contains("Inject") }).first?.parameters else { return }
        print(
            "        \(providerPropertyName(type.name)) = \(providerImplementationName(type))(" +
            parameters.map { "\($0.name)Provider: \(providerPropertyName($0.typeName.name))" } .joined(separator: ", ") +
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
