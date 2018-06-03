// swiftlint:disable identifier_name

@testable import Stiletto
import SourceryRuntime

extension Factory.Error: Equatable {
    static let noInit__ = Factory.Error.noInit(Type())
    static let multipleInits__ = Factory.Error.multipleInits(Type())

    public static func == (lhs: Factory.Error, rhs: Factory.Error) -> Bool {
        switch (lhs, rhs) {
        case (.noInit, .noInit): return true
        case (.multipleInits, .multipleInits): return true
        default: return false
        }
    }
}

extension Member.Error: Equatable {
    static let missingType__ = Member.Error.missingType(Variable(typeName: TypeName("")))

    public static func == (lhs: Member.Error, rhs: Member.Error) -> Bool {
        switch (lhs, rhs) {
        case (.missingType, .missingType): return true
        }
    }
}
