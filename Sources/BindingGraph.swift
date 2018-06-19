import SourceryRuntime

protocol BindingGraph {
    var bindings: [Binding] { get }
}

private struct _BindingGraph: BindingGraph {
    let bindings: [Binding]
}

protocol BindingGraphFactory {
    func makeGraph() throws -> BindingGraph
}

// sourcery: AutoInit
final class BindingGraphFactoryImpl: BindingGraphFactory {
    var types: Types!
    var bindingExtractor: BindingExtractor!

    func makeGraph() throws -> BindingGraph {
        let bindings = try types.all
            .filter { !$0.isModule && !$0.isComponent }
            .map(bindingExtractor.extractInjectionBindings)
            .reduce(Set<ProvisionBinding>()) { $0.union($1) }

        return _BindingGraph(
            bindings: Array(bindings)
        )
    }
}
