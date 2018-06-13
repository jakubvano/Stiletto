import SourceryRuntime

// sourcery: AutoMockable
protocol BindingFactory {
    func makeInjectionBinding(for type: Type, with constructor: SourceryRuntime.Method) throws -> ProvisionBinding
}

// sourcery: AutoInit
final class BindingFactoryImpl: BindingFactory {
    var keyFactory: BindingKeyFactory!
    var scopeParser: ScopeParser!
    var dependencyFactory: DependencyFactory!

    func makeInjectionBinding(for type: Type, with constructor: Method) throws -> ProvisionBinding {
        return ProvisionBinding(
            requiresModuleInstance: false,
            contributedType: type,
            key: try keyFactory.makeKey(for: type),
            kind: .injection,
            scope: try scopeParser.getScope(from: type),
            provisionDependencies: dependencyFactory.makeDependencies(from: constructor),
            membersInjectionDependencies: dependencyFactory.makeMemberDependencies(from: type)
        )
    }
}
