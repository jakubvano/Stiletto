import SourceryRuntime

struct FactoryDefinition {
    let interfaceName: String
    let implementationame: String
    let instanceTypeName: String
    let members: [Member]
    let constructor: Method

    struct Member {
        let name: String
        let typeName: String

        init(_ parameter: MethodParameter) {
            self.name = Member.name(for: parameter.typeName.name)
            self.typeName = "Provider<\(parameter.typeName)>"
        }

        static func name(for typeName: String) -> String {
            return Utils.camelCased(typeName) + "Provider"
        }
    }

    enum Error: Swift.Error {
        case noInit
        case multipleInits
    }

    init(_ type: Type) throws {
        let constructors = type.methods.filter(Utils.isInjectable).filter { $0.name == "init" }

        guard !constructors.isEmpty else { throw FactoryDefinition.Error.noInit }
        guard constructors.count == 1 else { throw FactoryDefinition.Error.multipleInits }

        self.interfaceName = "Provider<\(type.name)>"
        self.implementationame = "\(type.name)$$Factory"
        self.instanceTypeName = type.name
        self.constructor = constructors[0]
        self.members = constructor.parameters.map(Member.init)
    }
}
