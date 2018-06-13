import SourceryRuntime

// sourcery: AutoMockable
protocol BindingKeyFactory {
    func makeKey(for type: Type) throws -> BindingKey
}

final class BindingKeyFactoryImpl: BindingKeyFactory {
    func makeKey(for type: Type) throws -> BindingKey {
        return BindingKey(type: type)
    }

    func makeKey(for typed: Typed) throws -> BindingKey {
        if let type = typed.type {
            return BindingKey(type: type)
        } else {
            throw StilettoError.missingTypeInformation
        }
    }
}
