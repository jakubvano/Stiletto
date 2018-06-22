import SourceryRuntime

// sourcery: AutoMockable
protocol BindingFactory {
    func makeInjectionBinding(for type: Type, with constructor: SourceryMethod) throws -> ProvisionBinding
}

// sourcery: AutoInit
final class BindingFactoryImpl: BindingFactory {
    var keyFactory: BindingKeyFactory!
    var scopeParser: ScopeParser!
    var dependencyFactory: DependencyFactory!

    func makeInjectionBinding(for type: Type, with constructor: SourceryMethod) throws -> ProvisionBinding {
        return try ProvisionBinding(
            requiresModuleInstance: false,
            contributedType: type,
            key: keyFactory.makeKey(forType: type),
            kind: .injection,
            scope: scopeParser.getScope(from: type),
            provisionDependencies: dependencyFactory.makeDependencies(from: constructor),
            membersInjectionDependencies: dependencyFactory.makeMemberDependencies(from: type)
        )
    }
}
