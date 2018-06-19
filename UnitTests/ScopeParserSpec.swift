import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class ScopeParserSpec: QuickSpec {
    override func spec() {
        var parser: ScopeParserImpl!
        beforeEach {
            parser = ScopeParserImpl(types: Types(types: []))
        }

        context("given type annotated with valid scope") {
            it("returns scope") {
                let scope = makeScope(name: "FooScope")
                parser.types = Types(types: [scope])
                let type = makeType(annotations: ["FooScope"])

                let result = try? parser.getScope(from: type)

                expect(result) == scope
            }
        }
        context("given type annotated with type not based on Scope") {
            it("returns nil") {
                parser.types = Types(types: [Protocol(name: "FooScope")])
                let type = makeType(annotations: ["FooScope"])

                let result = try? parser.getScope(from: type)

                expect(result ?? nil).to(beNil())
            }
        }
        context("given type annotated with multiple scopes") {
            it("throws") {
                parser.types = Types(types: [ makeScope(name: "FooScope"), makeScope(name: "BarScope")])
                let type = makeType(annotations: ["FooScope", "BarScope"])
                expect { try parser.getScope(from: type) }
                    .to(throwError(StilettoError.duplicitScopeDeclaration))
            }
        }
        context("given type with multiple annotations, one valid scope") {
            it("does not throw") {
                parser.types = Types(types: [makeScope(name: "FooScope")])
                let type = makeType(annotations: ["FooScope", "BarScope"])
                expect { try parser.getScope(from: type) }.notTo(throwError())
            }
        }
    }
}

private func makeScope(name: String) -> SourceryRuntime.`Protocol` {
    let scope = Protocol(name: name)
    scope.based = ["Scope": ""]
    return scope
}

private func makeType(annotations: [String]) -> Type {
    var dict = [String: NSObject]()
    annotations.forEach { dict[$0] = NSObject() }
    return Type(annotations: dict)
}
