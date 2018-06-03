import SourceryRuntime

struct Stiletto {
    let components: [Component]
    let factories: [Factory]

    init(_ types: Types) throws {
        components = try types.all.filter(Utils.isComponent).map(Component.init)
        factories = try components
            .flatMap { $0.members }
            .map { $0.type }
            .reduce([], Utils.appendIfNew)
            .map(Factory.init)
    }
}
