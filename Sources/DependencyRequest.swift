import SourceryRuntime

struct DependencyRequest: AutoHashable {
    let key: BindingKey
    let kind: Kind

    enum Kind {
        case instance, membersInjection
    }
}

// sourcery: AutoMockable
protocol DependencyFactory {
    func makeDependencies(from method: SourceryRuntime.Method) -> Set<DependencyRequest>
    func makeMemberDependencies(from type: Type) -> Set<DependencyRequest>
}
