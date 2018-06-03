import SourceryRuntime

struct FactoryDefinition {
    let interfaceName: String
    let implementationame: String
    let members: [Member]
    let constructor: Constructor

    struct Member {
        let name: String
        let typeName: String
    }

    struct Constructor {
        let callName: String
        let params: [Member]
    }

    enum Error: Swift.Error {
        case noInit
        case multipleInits
    }

    init(for type: Type) throws {
        let constructors = type.methods.filter(Utils.isInjectable).filter { $0.name == "init" }

        guard !constructors.isEmpty else { throw FactoryDefinition.Error.noInit }
        guard constructors.count == 1 else { throw FactoryDefinition.Error.multipleInits }

        interfaceName = "Provider<\(type.name)>"
        implementationame = "\(type.name)$$Factory"
        members = []
        constructor = Constructor(callName: "", params: [])
    }
}
