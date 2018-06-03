import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class MemberSpec: QuickSpec {
    override func spec() {
        describe("names") {
            it("has correct name") {
                let member = try? Member(Variable(typeName: TypeName("Foo"), type: Type(name: "Foo")))
                expect(member?.name) == "fooProvider"
            }
            it("has correct type name") {
                let member = try? Member(Variable(typeName: TypeName("Foo"), type: Type(name: "Foo")))
                expect(member?.typeName) == "Provider<Foo>"
            }
        }
        describe("type") {
            it("throws if not type available") {
                expect { try Member(Variable(typeName: TypeName("Foo"), type: nil)) }
                    .to(throwError(Member.Error.missingType))
            }
            it("has correct type") {
                let type = Type(name: "Foo")
                let member = try? Member(Variable(typeName: TypeName("Foo"), type: type))
                expect(member?.type) == type
            }
        }
        describe("member name creation") {
            it("returns correct value") {
                expect(Member.name(for: "Foo")) == "fooProvider"
            }
        }
    }
}
