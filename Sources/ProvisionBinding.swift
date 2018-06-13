import SourceryRuntime

struct ProvisionBinding: ContributionBinding {
    let requiresModuleInstance: Bool
    let contributedType: Type
    let key: BindingKey
    let kind: BindingKind
    let scope: Type?
    let provisionDependencies: Set<DependencyRequest>
    let membersInjectionDependencies: Set<DependencyRequest>
}

extension ProvisionBinding {
    var dependencies: Set<DependencyRequest> {
        return provisionDependencies.union(membersInjectionDependencies)
    }
}
