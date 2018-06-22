import SourceryRuntime

protocol Scope {}

// sourcery: AutoMockable
protocol ScopeParser {
    func getScope(from type: Type) throws -> SourceryProtocol?
}

// sourcery: AutoInit
final class ScopeParserImpl: ScopeParser {
    var types: Types!

    func getScope(from type: Type) throws -> SourceryProtocol? {
        let scopes = types.protocols
            .filter { $0.based.keys.contains(String(describing: Scope.self)) }
            .filter { type.annotations.keys.contains($0.name) }

        guard scopes.count <= 1 else { throw StilettoError.duplicitScopeDeclaration }

        return scopes.first
    }
}

func hello() {
    print("Helloo world")
}
