import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class StilettoSpec: QuickSpec {
    override func spec() {
        describe("compoenents") {
            it("contains types components from annotated types") {
                let type = Type(name: "Foo", annotations: ["Component": NSObject()])
                let componentNames = try? Stiletto(Types(types: [type])).components.map { $0.implementationName }
                expect(componentNames).to(contain("StilettoFoo"))
            }
            it("does not contain compononents from not annotated types") {
                let type = Type(name: "Foo")
                let componentNames = try? Stiletto(Types(types: [type])).components.map { $0.implementationName }
                expect(componentNames).notTo(contain("StilettoFoo"))
            }
        }
        describe("factories") {
            it("contains factories for all component members") {
                let type = Type(
                    variables: [Variable(typeName: TypeName(typeD.name), type: typeD)],
                    annotations: ["Component": NSObject()]
                )
                let typeNames = try? Stiletto(Types(types: [type])).factories.map { $0.instanceTypeName }
                expect(typeNames).to(contain(["A", "B", "C", "D"]))
            }
            it("does not contain duplicit factories") {
                let type1 = Type(
                    name: "1",
                    variables: [Variable(typeName: TypeName(typeD.name), type: typeD)],
                    annotations: ["Component": NSObject()]
                )
                let type2 = Type(
                    name: "2",
                    variables: [Variable(typeName: TypeName(typeC.name), type: typeC)],
                    annotations: ["Component": NSObject()]
                )
                let stiletto = try? Stiletto(Types(types: [type1, type2]))
                expect(stiletto?.factories).to(haveCount(4))
            }
        }
    }
}
