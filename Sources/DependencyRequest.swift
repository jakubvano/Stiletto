import SourceryRuntime

struct DependencyRequest: AutoHashable {
    let key: BindingKey
}

// sourcery: AutoMockable
protocol DependencyFactory {
    func makeDependencies(from method: SourceryMethod) throws -> Set<DependencyRequest>
    func makeMemberDependencies(from type: Type) throws -> Set<DependencyRequest>
}

// sourcery: AutoInit
final class DependencyFactoryImpl: DependencyFactory {
    var keyFactory: BindingKeyFactory!

    func makeMemberDependencies(from type: Type) throws -> Set<DependencyRequest> {
        return Set()
    }

    func makeDependencies(from method: SourceryMethod) throws -> Set<DependencyRequest> {
        return try Set(method.parameters
            .map(keyFactory.makeKey(forVariable:))
            .map(DependencyRequest.init)
        )
    }
}
