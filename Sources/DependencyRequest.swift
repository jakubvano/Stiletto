import SourceryRuntime

struct DependencyRequest: AutoHashable {
    let key: BindingKey
    let kind: Kind

    enum Kind {
        case instance, membersInjection
    }
}
