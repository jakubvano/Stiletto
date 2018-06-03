import SourceryRuntime

enum Utils {
    static func isInjectable(_ identifier: Annotated) -> Bool {
        return identifier.annotations.keys.contains("Inject")
    }

    static func camelCased(_ name: String) -> String {
        return name.prefix(1).lowercased() + name.dropFirst()
    }
}
