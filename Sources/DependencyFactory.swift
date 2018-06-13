import SourceryRuntime

// sourcery: AutoMockable
protocol DependencyFactory {
    func makeDependencies(from method: SourceryRuntime.Method) -> Set<DependencyRequest>
    func makeMemberDependencies(from type: Type) -> Set<DependencyRequest>
}
