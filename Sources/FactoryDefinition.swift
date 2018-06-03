import SourceryRuntime

struct FactoryDefinition {
    let interfaceName: String
    let implementationame: String
    let members: [Member]
    let constructor: Method

    struct Member {
        let name: String
        let typeName: String
    }

    enum Error: Swift.Error {
        case noInit
        case multipleInits
    }

    init(for type: Type) throws {
        let constructors = type.methods.filter(Utils.isInjectable).filter { $0.name == "init" }

        guard !constructors.isEmpty else { throw FactoryDefinition.Error.noInit }
        guard constructors.count == 1 else { throw FactoryDefinition.Error.multipleInits }

        self.interfaceName = "Provider<\(type.name)>"
        self.implementationame = "\(type.name)$$Factory"
        self.members = []
        self.constructor = constructors[0]
    }
}
