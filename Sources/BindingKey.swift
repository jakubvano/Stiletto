import SourceryRuntime

struct BindingKey: AutoHashable {
    let type: Type
}

// sourcery: AutoMockable
protocol BindingKeyFactory {
    func makeKey(forType type: Type) throws -> BindingKey
    func makeKey(forVariable typed: Typed) throws -> BindingKey
}

final class BindingKeyFactoryImpl: BindingKeyFactory {
    func makeKey(forType type: Type) throws -> BindingKey {
        return BindingKey(type: type)
    }

    func makeKey(forVariable typed: Typed) throws -> BindingKey {
        if let type = typed.type {
            return BindingKey(type: type)
        } else {
            throw StilettoError.missingTypeInformation
        }
    }
}
