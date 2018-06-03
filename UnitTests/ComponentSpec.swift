import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class ComponentSpec: QuickSpec {
    override func spec() {
        describe("names") {
            it("has correct implementation name") {
                let component = try? Component(Type(name: "MyComponent"))
                expect(component?.implementationName) == "StilettoMyComponent"
            }
            it("has correct interface name") {
                let component = try? Component(Type(name: "MyComponent"))
                expect(component?.interfaceName) == "MyComponent"
            }
        }
        describe("members") {
            it("contains protocol variables") {
                let type = Type(variables: [
                    Variable(typeName: TypeName("Foo"), type: Type(name: "Foo")),
                    Variable(typeName: TypeName("Bar"), type: Type(name: "Bar"))
                ])
                let memberNames = try? Component(type).members.map { $0.name }
                expect(memberNames).to(contain("fooProvider"))
                expect(memberNames).to(contain("barProvider"))
            }
            // TODO: dependencies of variable types
        }
    }
}
