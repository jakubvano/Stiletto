// swiftlint:disable function_body_length

import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class BindingGraphFactorySpec: QuickSpec {
    override func spec() {
        var bindingExtractor: BindingExtractorMock!
        var factory: BindingGraphFactoryImpl!
        beforeEach {
            bindingExtractor = BindingExtractorMock()
            bindingExtractor.extractInjectionBindingsFromReturnValue = Set()
            factory = BindingGraphFactoryImpl(
                types: Types(types: []),
                bindingExtractor: bindingExtractor
            )
        }
        describe("bindings") {
            context("no types") {
                it("returns empty set") {
                    factory.types = Types(types: [])
                    let graph = factory.makeGraph()
                    expect(graph.bindings).to(beEmpty())
                }
            }
        }
        describe("injection bindings") {
            context("single type") {
                let type = Type(name: "Foo")
                beforeEach {
                    factory.types = Types(types: [type])
                }
                it("extracts injection bindings from given type") {
                    _ = factory.makeGraph()
                    expect(bindingExtractor.extractInjectionBindingsFromReceivedType) == type
                }
                it("contains injection bindings returned from extractor") {
                    let bindings = Set([binding(for: Type(name: "Foo")), binding(for: Type(name: "Bar"))])
                    bindingExtractor.extractInjectionBindingsFromReturnValue = bindings
                    let result = factory.makeGraph().bindings.compactMap { $0 as? ProvisionBinding }
                    expect(result).to(contain(Array(bindings)))
                }
            }
            context("multiple types") {
                beforeEach {
                    factory.types = Types(types: [Type(name: "Foo"), Type(name: "Bar"), Type(name: "Ook")])
                }
                it("extracts injection binding from all types") {
                    _ = factory.makeGraph()
                    expect(bindingExtractor.extractInjectionBindingsFromCallsCount) == 3
                }
                it("contains injection bindings returned from extractor") {
                    bindingExtractor.extractInjectionBindingsFromClosure = { Set([binding(for: $0)]) }
                    let bindings = factory.makeGraph().bindings.compactMap { $0 as? ProvisionBinding }
                    expect(bindings).to(contain(binding(for: Type(name: "Foo"))))
                    expect(bindings).to(contain(binding(for: Type(name: "Bar"))))
                    expect(bindings).to(contain(binding(for: Type(name: "Ook"))))
                }
            }
            context("given module") {
                it("does not extract injection bindings") {
                    factory.types = Types(types: [Type(annotations: ["Module": NSObject()])])
                    _ = factory.makeGraph()
                    expect(bindingExtractor.extractInjectionBindingsFromCalled) == false
                }
            }
            context("given component") {
                it("does not extract injection bindings") {
                    factory.types = Types(types: [Type(annotations: ["Component": NSObject()])])
                    _ = factory.makeGraph()
                    expect(bindingExtractor.extractInjectionBindingsFromCalled) == false
                }
            }
        }
    }
}

private func binding(for type: Type) -> ProvisionBinding {
    return ProvisionBinding(
        requiresModuleInstance: false,
        contributedType: type,
        key: BindingKey(type: type),
        kind: .injection,
        scope: nil,
        provisionDependencies: Set(),
        membersInjectionDependencies: Set()
    )
}
