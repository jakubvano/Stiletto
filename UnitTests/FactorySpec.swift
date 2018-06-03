// swiftlint:disable function_body_length

import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class FactorySpec: QuickSpec {
    override func spec() {
        describe("names") {
            it("has the correct implementation name") {
                let definition = try? Factory(type(name: "Foo"))
                expect(definition?.implementationName) == "Foo$$Factory"
            }
            it("has the correct interface name") {
                let definition = try? Factory(type(name: "Foo"))
                expect(definition?.interfaceName) == "Provider<Foo>"
            }
            it("has the correct instance type name") {
                let definition = try? Factory(type(name: "Foo"))
                expect(definition?.instanceTypeName) == "Foo"
            }
        }
        describe("constructor") {
            it("is the injectable init method") {
                let constructor = Method(name: "init", annotations: ["Inject": NSObject()])
                let definition = try? Factory(type(methods: [
                    Method(name: "init"),
                    constructor,
                    Method(name: "custom", annotations: ["Inject": NSObject()])
                    ]))
                expect(definition?.constructor) == constructor
            }
        }
        describe("members") {
            it("has the count equal to constructor params") {
                let definition = try? Factory(type(methods: [
                    Method(
                        name: "init",
                        parameters: [
                            MethodParameter(name: "foo", typeName: TypeName("Foo"), type: Type(name: "Foo")),
                            MethodParameter(name: "bar", typeName: TypeName("Bar"), type: Type(name: "Bar"))
                        ],
                        annotations: ["Inject": NSObject()]
                    )
                ]))
                expect(definition?.members).to(haveCount(2))
            }
            it("has the correct names") {
                let definition = try? Factory(type(methods: [
                    Method(
                        name: "init",
                        parameters: [MethodParameter(name: "foo", typeName: TypeName("Bar"), type: Type(name: "Bar"))],
                        annotations: ["Inject": NSObject()]
                    )
                ]))
                expect(definition?.members.first?.name) == "barProvider"
                expect(definition?.members.first?.typeName) == "Provider<Bar>"
            }
        }
        describe("errors") {
            it("throws if no methods available") {
                expect { try Factory(type(methods: [])) }
                    .to(throwError(Factory.Error.noInit__))
            }
            it("throws if no init found") {
                expect { try Factory(type(methods: [Method(name: "custom")])) }
                    .to(throwError(Factory.Error.noInit__))
            }
            it("throws if no injectable init found") {
                expect { try Factory(type(methods: [Method(name: "init")])) }
                    .to(throwError(Factory.Error.noInit__))
            }
            it("throws if multiple injectable init found") {
                expect {
                        try Factory(type(methods: [
                            Method(name: "init", annotations: ["Inject": NSObject()]),
                            Method(name: "init", annotations: ["Inject": NSObject()])
                        ]))
                    }
                    .to(throwError(Factory.Error.multipleInits__))
            }
            it("does not throw if injectable init with params found") {
                expect {
                    try Factory(type(methods: [
                            Method(name: "init(param:)", annotations: ["Inject": NSObject()])
                        ]))
                    }
                    .notTo(throwError())
            }
            it("does not throw if multiple non-injectable inits found") {
                expect {
                        try Factory(type(methods: [
                            Method(name: "init", annotations: ["Inject": NSObject()]),
                            Method(name: "init")
                        ]))
                    }
                    .notTo(throwError())
            }
            it("does not throw if multiple injectable non-inits found") {
                expect {
                    try Factory(type(methods: [
                            Method(name: "init", annotations: ["Inject": NSObject()]),
                            Method(name: "custom", annotations: ["Inject": NSObject()])
                        ]))
                    }
                    .notTo(throwError())
            }
        }
    }
}

private func type(
    name: String = "",
    methods: [Method] = [Method(name: "init", annotations: ["Inject": NSObject()])]
) -> Type {
    return Type(name: name, methods: methods)
}

typealias Method = SourceryRuntime.Method
