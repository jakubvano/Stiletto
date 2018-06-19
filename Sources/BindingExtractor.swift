import SourceryRuntime

// sourcery: AutoMockable
protocol BindingExtractor {
    func extractInjectionBindings(from type: Type) -> Set<ProvisionBinding>
}
