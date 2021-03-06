import SourceryRuntime

protocol Binding {
    var key: BindingKey { get }
    var kind: BindingKind { get }
    var dependencies: Set<DependencyRequest> { get }
    var scope: SourceryProtocol? { get }
}

enum BindingKind {
    case injection, provision, component, membersInjector
}

protocol ContributionBinding: Binding {
    var requiresModuleInstance: Bool { get }
    var contributedType: Type { get }
}

struct ProvisionBinding: ContributionBinding, AutoHashable {
    let requiresModuleInstance: Bool
    let contributedType: Type
    let key: BindingKey
    let kind: BindingKind
    let scope: SourceryProtocol?
    let provisionDependencies: Set<DependencyRequest>
    let membersInjectionDependencies: Set<DependencyRequest>
}

extension ProvisionBinding {
    var dependencies: Set<DependencyRequest> {
        return provisionDependencies.union(membersInjectionDependencies)
    }
}
