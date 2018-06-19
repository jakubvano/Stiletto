import SourceryRuntime

extension Type {
    var isModule: Bool { return annotations.keys.contains("Module") }
    var isComponent: Bool { return annotations.keys.contains("Component") }
}
