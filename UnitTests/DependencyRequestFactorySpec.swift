import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class DependencyRequestFactorySpec: QuickSpec {
    override func spec() {
        var factory: DependencyFactoryImpl!
        var keyFactory: BindingKeyFactoryMock!
        beforeEach {
            keyFactory = BindingKeyFactoryMock()
            keyFactory.makeKeyForTypeReturnValue = BindingKey(type: Type())
            keyFactory.makeKeyForVariableReturnValue = BindingKey(type: Type())
            factory = DependencyFactoryImpl(
                keyFactory: keyFactory
            )
        }
        describe("makeDependenciesFromMethod") {
            context("method without parameters") {
                it("returns an empty set") {
                    let result = try? factory.makeDependencies(from: makeMethod())
                    expect(result).to(beEmpty())
                }
            }
            context("method with single parameter") {
                let parameter = makeParameter()
                let method = makeMethod(parameters: [parameter])
                it("generates key for parameter") {
                    _ = try? factory.makeDependencies(from: method)
                    expect(keyFactory.makeKeyForVariableReceivedTyped as? MethodParameter) == parameter
                }
                it("rethrows keyFactory error") {
                    keyFactory.makeKeyForVariableThrowableError = Error()
                    expect { try factory.makeDependencies(from: method) }.to(throwError())
                }
                it("produces request with generated key") {
                    let key = BindingKey(type: Type(name: "Foo"))
                    keyFactory.makeKeyForVariableReturnValue = key
                    let result = try? factory.makeDependencies(from: method)
                    expect(result?.first?.key) == key
                }
            }
            context("method with multiple parameters") {
                let method = makeMethod(parameters: [
                    makeParameter(type: Type(name: "Foo")),
                    makeParameter(type: Type(name: "Bar")),
                    makeParameter(type: Type(name: "Ook"))
                ])
                it("generates key for each parameter") {
                    _ = try? factory.makeDependencies(from: method)
                    expect(keyFactory.makeKeyForVariableCallsCount) == 3
                }
                it("returns dependency request for each parameter") {
                    keyFactory.makeKeyForVariableClosure = { BindingKey(type: Type(name: $0.typeName.name)) }
                    let result = try? factory.makeDependencies(from: method)
                    expect(result).to(haveCount(3))
                }
            }
        }
    }
}

private func makeParameter(type: Type? = Type()) -> MethodParameter {
    return MethodParameter(argumentLabel: nil, typeName: TypeName(type?.name ?? ""), type: type)
}

private func makeMethod(parameters: [MethodParameter] = []) -> SourceryMethod {
    return SourceryMethod(name: "", parameters: parameters)
}
