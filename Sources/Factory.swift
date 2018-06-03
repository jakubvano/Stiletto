import SourceryRuntime

struct Factory {
    let interfaceName: String
    let implementationame: String
    let instanceTypeName: String
    let members: [Member]
    let constructor: Method

    enum Error: Swift.Error {
        case noInit
        case multipleInits
    }

    init(_ type: Type) throws {
        let constructors = type.methods.filter(Utils.isInjectable).filter { $0.name == "init" }

        guard !constructors.isEmpty else { throw Factory.Error.noInit }
        guard constructors.count == 1 else { throw Factory.Error.multipleInits }

        self.interfaceName = "Provider<\(type.name)>"
        self.implementationame = "\(type.name)$$Factory"
        self.instanceTypeName = type.name
        self.constructor = constructors[0]
        self.members = constructor.parameters.map(Member.init)
    }
}
