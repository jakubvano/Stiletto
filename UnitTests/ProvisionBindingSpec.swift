import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class ProvisionBindingSpec: QuickSpec {
    override func spec() {
        describe("dependencies") {
            it("is union of provision and member inejction dependencies") {
                let fooDependency = DependencyRequest(key: BindingKey(type: Type(name: "Foo")), kind: .instance)
                let barDependency = DependencyRequest(key: BindingKey(type: Type(name: "bar")), kind: .membersInjection)
                let binding = ProvisionBinding(
                    requiresModuleInstance: true,
                    contributedType: Type(),
                    key: BindingKey(type: Type()),
                    kind: .component,
                    scope: nil,
                    provisionDependencies: Set([fooDependency]),
                    membersInjectionDependencies: Set([barDependency])
                )
                expect(binding.dependencies).to(contain([fooDependency, barDependency]))
            }
        }
    }
}
