import SourceryRuntime

// sourcery: AutoMockable
protocol ScopeParser {
    func getScope(from type: Type) throws -> SourceryRuntime.`Protocol`?
}

// sourcery: AutoInit
final class ScopeParserImpl: ScopeParser {
    var types: Types!

    func getScope(from type: Type) throws -> Protocol? {
        let scopes = types.protocols
            .filter { $0.based.keys.contains(String(describing: Scope.self)) }
            .filter { type.annotations.keys.contains($0.name) }

        guard scopes.count <= 1 else { throw StilettoError.duplicitScopeDeclaration }

        return scopes.first
    }
}
