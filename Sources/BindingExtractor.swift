import SourceryRuntime

// sourcery: AutoMockable
protocol BindingExtractor {
    func extractInjectionBindings(from type: Type) throws -> Set<ProvisionBinding>
}

// sourcery: AutoInit
final class BindingExtractorImpl: BindingExtractor {
    var bindingFactory: BindingFactory!

    func extractInjectionBindings(from type: Type) throws -> Set<ProvisionBinding> {
        let bindings = try type.methods
            .filter { $0.isInjectable && $0.isStatic && $0.returnType == type }
            .map { try bindingFactory.makeInjectionBinding(for: type, with: $0) }

        return Set(bindings)
    }
}
