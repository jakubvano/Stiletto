// swiftlint:disable function_body_length

import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class BindingExtractorSpec: QuickSpec {
    override func spec() {
        var bindingFactory: BindingFactoryMock!
        var extractor: BindingExtractorImpl!
        beforeEach {
            bindingFactory = BindingFactoryMock()
            bindingFactory.makeInjectionBindingForWithReturnValue = binding(for: Type())
            extractor = BindingExtractorImpl(
                bindingFactory: bindingFactory
            )
        }
        describe("extractInjectionBindings") {
            context("given type without injectable methods") {
                it("returns empty set") {
                    let result = try? extractor.extractInjectionBindings(from: Type())
                    expect(result).to(beEmpty())
                }
            }
            context("given type with single injectable constructor") {
                let constructor = makeConstructor()
                let type = makeType(methods: [constructor])
                it("calls binding factory with type and constructor") {
                    _  = try? extractor.extractInjectionBindings(from: type)
                    expect(bindingFactory.makeInjectionBindingForWithReceivedArguments?.0) == type
                    expect(bindingFactory.makeInjectionBindingForWithReceivedArguments?.1) == constructor
                }
                it("rethrows factory error") {
                    bindingFactory.makeInjectionBindingForWithThrowableError = Error()
                    expect { try extractor.extractInjectionBindings(from: type) }
                        .to(throwError())
                }
                it("returns set with factory result") {
                    let factoryResult = binding(for: Type(name: "Foo"))
                    bindingFactory.makeInjectionBindingForWithReturnValue = factoryResult
                    let set = try? extractor.extractInjectionBindings(from: type)
                    expect(set).to(contain(factoryResult))
                }
            }
            context("given type with non-injectable method") {
                it("does not invoke binding factory") {
                    let type = makeType(methods: [makeConstructor(isInjectable: false)])
                    _ = try? extractor.extractInjectionBindings(from: type)
                    expect(bindingFactory.makeInjectionBindingForWithCalled) == false
                }
            }
            context("given type with not static injectable method") {
                it("does not invoke binding factory") {
                    let type = makeType(methods: [makeConstructor(isStatic: false)])
                    _ = try? extractor.extractInjectionBindings(from: type)
                    expect(bindingFactory.makeInjectionBindingForWithCalled) == false
                }
            }
            context("given type with static injectable method not returning type") {
                it("does not invoke binding factory") {
                    let type = makeType(methods: [makeConstructor()], setReturnType: false)
                    _ = try? extractor.extractInjectionBindings(from: type)
                    expect(bindingFactory.makeInjectionBindingForWithCalled) == false
                }
            }
            context("given type with multiple constructors") {
                let type = makeType(methods: [
                    makeConstructor(name: "foo"), makeConstructor(name: "bar"), makeConstructor(name: "ook")
                ])
                it("invokes factory with each one") {
                    _ = try? extractor.extractInjectionBindings(from: type)
                    expect(bindingFactory.makeInjectionBindingForWithCallsCount) == 3
                }
                it("returns set containing all factory results") {
                    bindingFactory.makeInjectionBindingForWithClosure = { binding(for: Type(name: $1.name)) }
                    let set = try? extractor.extractInjectionBindings(from: type)
                    expect(set).to(haveCount(3))
                }
            }
        }
    }
}

private func makeConstructor(
    name: String = "",
    isInjectable: Bool = true,
    isStatic: Bool = true
) -> SourceryRuntime.Method {
    return SourceryRuntime.Method(
        name: name,
        isStatic: isStatic,
        annotations: isInjectable ? ["Inject": NSObject()] : [:]
    )
}

private func makeType(
    methods: [SourceryRuntime.Method] = [makeConstructor()],
    setReturnType: Bool = true
) -> Type {
    let type = Type(methods: methods)
    if setReturnType { methods.forEach { $0.returnType = type } }
    return type
}
