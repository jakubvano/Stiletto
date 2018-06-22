import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class BindingKeyFactorySpec: QuickSpec {
    override func spec() {
        var factory: BindingKeyFactoryImpl!
        beforeEach { factory = BindingKeyFactoryImpl() }

        describe("for type input") {
            it("produces a key with the given type") {
                let type = Type(name: "Foo")
                let key = try? factory.makeKey(forType: type)
                expect(key?.type) == type
            }
        }
        describe("for typed input") {
            context("given input with a type") {
                it("produces a key with the given type") {
                    let type = Type(name: "Foo")
                    let variable = Variable(typeName: TypeName("Foo"), type: type) as Typed
                    let key = try? factory.makeKey(forVariable: variable)
                    expect(key?.type) == type
                }
            }
            context("given input without a type") {
                it("throws error") {
                    let parameter = MethodParameter(typeName: TypeName("Foo")) as Typed
                    expect { try factory.makeKey(forVariable: parameter) }
                        .to(throwError(StilettoError.missingTypeInformation))
                }
            }
        }
    }
}
