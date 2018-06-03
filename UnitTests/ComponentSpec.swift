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
            it("contains type variables") {
                let type = Type(variables: [
                    Variable(typeName: TypeName(typeA.name), type: typeA),
                    Variable(typeName: TypeName(typeB.name), type: typeB)
                ])
                let memberTypes = try? Component(type).members.map { $0.type }
                expect(memberTypes).to(contain(typeA))
                expect(memberTypes).to(contain(typeB))
            }
            it("contains dependencies of type variable") {
                let type = Type(variables: [Variable(typeName: TypeName(typeC.name), type: typeC)])
                let memberTypes = try? Component(type).members.map { $0.type }
                expect(memberTypes).to(contain(typeB))
            }
            it("contains dependencies of dependencies of type variable") {
                let type = Type(variables: [Variable(typeName: TypeName(typeC.name), type: typeC)])
                let memberTypes = try? Component(type).members.map { $0.type }
                expect(memberTypes).to(contain(typeA))
            }
            it("does not contain duplicities") {
                let type = Type(variables: [Variable(typeName: TypeName(typeD.name), type: typeD)])
                let members = try? Component(type).members
                expect(members).to(haveCount(4))
            }
            it("contains members sorted by dependency tree") {
                let type = Type(variables: [
                    Variable(typeName: TypeName(typeD.name), type: typeD),
                    Variable(typeName: TypeName(typeA.name), type: typeA)
                ])
                let memberTypes = try? Component(type).members.map { $0.type }
                expect(memberTypes) == [typeA, typeB, typeC, typeD]
            }
        }
        describe("variables") {
            it("is the same as variables of type") {
                let variables = [
                    Variable(typeName: TypeName(typeA.name), type: typeA),
                    Variable(typeName: TypeName(typeB.name), type: typeB)
                ]
                let component = try? Component(Type(variables: variables))
                expect(component?.variables) == variables
            }
        }
    }
}
