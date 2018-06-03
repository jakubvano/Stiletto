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

private let typeA = Type(
    name: "A",
    methods: [Method(name: "init", annotations: ["Inject": NSObject()])]
)
private let typeB = Type(
    name: "B",
    methods: [Method(
        name: "init",
        parameters: [MethodParameter(typeName: TypeName(typeA.name), type: typeA)],
        annotations: ["Inject": NSObject()]
    )]
)
private let typeC = Type(
    name: "C",
    methods: [Method(
        name: "init",
        parameters: [MethodParameter(typeName: TypeName(typeB.name), type: typeB)],
        annotations: ["Inject": NSObject()]
    )]
)
private let typeD = Type(
    name: "D",
    methods: [Method(
        name: "init",
        parameters: [
            MethodParameter(typeName: TypeName(typeB.name), type: typeB),
            MethodParameter(typeName: TypeName(typeC.name), type: typeC)
        ],
        annotations: ["Inject": NSObject()]
    )]
)
