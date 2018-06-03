import SourceryRuntime

func isInjectable(_ identifier: Annotated) -> Bool {
    return identifier.annotations.keys.contains("Inject")
}

func camelCased(_ name: String) -> String {
    return name.prefix(1).lowercased() + name.dropFirst()
}
