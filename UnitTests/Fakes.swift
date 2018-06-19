import SourceryRuntime
@testable import Stiletto

func binding(for type: Type) -> ProvisionBinding {
    return ProvisionBinding(
        requiresModuleInstance: false,
        contributedType: type,
        key: BindingKey(type: type),
        kind: .injection,
        scope: nil,
        provisionDependencies: Set(),
        membersInjectionDependencies: Set()
    )
}

struct Error: Swift.Error {}
