import SourceryRuntime

protocol Binding {
    var key: BindingKey { get }
    var kind: BindingKind { get }
    var dependencies: Set<DependencyRequest> { get }
    var scope: SourceryRuntime.`Protocol`? { get }
}

enum BindingKind {
    case injection, provision, component, membersInjector
}

protocol ContributionBinding: Binding {
    var requiresModuleInstance: Bool { get }
    var contributedType: Type { get }
}
