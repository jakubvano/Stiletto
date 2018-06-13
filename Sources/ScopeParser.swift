import SourceryRuntime

// sourcery: AutoMockable
protocol ScopeParser {
    func getScope(from type: Type) -> Type?
}
