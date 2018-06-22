// swiftlint:disable function_body_length

import Quick
import Nimble
import SourceryRuntime
@testable import Stiletto

class BindingFactorySpec: QuickSpec {
    override func spec() {
        var factory: BindingFactoryImpl!
        var keyFactory: BindingKeyFactoryMock!
        var scopeParser: ScopeParserMock!
        var dependencyFactory: DependencyFactoryMock!
        beforeEach {
            keyFactory = BindingKeyFactoryMock()
            keyFactory.makeKeyForTypeReturnValue = BindingKey(type: Type())
            keyFactory.makeKeyForVariableReturnValue = BindingKey(type: Type())
            scopeParser = ScopeParserMock()
            scopeParser.getScopeFromReturnValue = SourceryProtocol()
            dependencyFactory = DependencyFactoryMock()
            dependencyFactory.makeDependenciesFromReturnValue = Set()
            dependencyFactory.makeMemberDependenciesFromReturnValue = Set()
            factory = BindingFactoryImpl(
                keyFactory: keyFactory,
                scopeParser: scopeParser,
                dependencyFactory: dependencyFactory
            )
        }

        describe("makeInjectionBinding") {
            describe("contributedType") {
                it("contributes given type") {
                    let type = makeType(name: "Foo")
                    let binding = try? factory.makeInjectionBinding(for: type, with: makeConstructor())
                    expect(binding?.contributedType) == type
                }
            }
            describe("kind") {
                it("is injection") {
                    let binding = try? factory.makeInjectionBinding(for: makeType(), with: makeConstructor())
                    expect(binding?.kind) == .injection
                }
            }
            describe("requiresModuleInstance") {
                it("is false") {
                    let binding = try? factory.makeInjectionBinding(for: makeType(), with: makeConstructor())
                    expect(binding?.requiresModuleInstance) == false
                }
            }
            describe("key") {
                it("creates key using given key factory") {
                    keyFactory.makeKeyForTypeReturnValue = BindingKey(type: Type(name: "Foo"))
                    let binding = try? factory.makeInjectionBinding(for: makeType(), with: makeConstructor())
                    expect(binding?.key) == keyFactory.makeKeyForTypeReturnValue
                }
                it("uses given type when requesting the key") {
                    let type = makeType(name: "Foo")
                    _ = try? factory.makeInjectionBinding(for: type, with: makeConstructor())
                    expect(keyFactory.makeKeyForTypeReceivedType) == type
                }
                it("throws given throwing key factory") {
                    keyFactory.makeKeyForTypeThrowableError = Error()
                    expect { try factory.makeInjectionBinding(for: makeType(), with: makeConstructor()) }
                        .to(throwError())
                }
            }
            describe("scope") {
                it("gets scope using given scope parser") {
                    scopeParser.getScopeFromReturnValue = SourceryProtocol(name: "Scope")
                    let binding = try? factory.makeInjectionBinding(for: makeType(), with: makeConstructor())
                    expect(binding?.scope) == scopeParser.getScopeFromReturnValue
                }
                it("uses given type when requesting the scope") {
                    let type = makeType(name: "Foo")
                    _ = try? factory.makeInjectionBinding(for: type, with: makeConstructor())
                    expect(scopeParser.getScopeFromReceivedType) == type
                }
                it("throws given throwing scope parser") {
                    scopeParser.getScopeFromThrowableError = Error()
                    expect { try factory.makeInjectionBinding(for: makeType(), with: makeConstructor()) }
                        .to(throwError())
                }
            }
            describe("provisionDependencies") {
                it("gets dependencies using given dependency parser") {
                    dependencyFactory.makeDependenciesFromReturnValue = Set(
                        [makeDependency(key: BindingKey(type: Type(name: "Foo")))]
                    )
                    let binding = try? factory.makeInjectionBinding(for: makeType(), with: makeConstructor())
                    expect(binding?.provisionDependencies) == dependencyFactory.makeDependenciesFromReturnValue
                }
                it("uses given constructor when requesting the dependencies") {
                    let constructor = makeConstructor(name: "Foo")
                    _ = try? factory.makeInjectionBinding(for: makeType(), with: constructor)
                    expect(dependencyFactory.makeDependenciesFromReceivedMethod) == constructor
                }
                it("rethrows dependency factory error") {
                    dependencyFactory.makeDependenciesFromThrowableError = Error()
                    expect { try factory.makeInjectionBinding(for: makeType(), with: makeConstructor()) }
                        .to(throwError())
                }
            }
            describe("membersInjectionDependencies") {
                it("gets dependencies using given dependency parser") {
                    dependencyFactory.makeMemberDependenciesFromReturnValue = Set(
                        [makeDependency(key: BindingKey(type: Type(name: "Foo")))]
                    )
                    let binding = try? factory.makeInjectionBinding(for: makeType(), with: makeConstructor())
                    expect(binding?.membersInjectionDependencies)
                        == dependencyFactory.makeMemberDependenciesFromReturnValue
                }
                it("uses given type when requesting the dependencies") {
                    let type = makeType(name: "Foo")
                    _ = try? factory.makeInjectionBinding(for: type, with: makeConstructor())
                    expect(dependencyFactory.makeMemberDependenciesFromReceivedType) == type
                }
                it("rethrows dependency factory error") {
                    dependencyFactory.makeMemberDependenciesFromThrowableError = Error()
                    expect { try factory.makeInjectionBinding(for: makeType(), with: makeConstructor()) }
                        .to(throwError())
                }
            }
        }
    }
}

private func makeType(name: String = "") -> Type {
    return Type(name: name)
}

private func makeConstructor(name: String = "") -> SourceryMethod {
    return SourceryRuntime.Method(name: name)
}

private func makeDependency(key: BindingKey = BindingKey(type: Type())) -> DependencyRequest {
    return DependencyRequest(key: key)
}
