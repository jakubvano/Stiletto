import SourceryRuntime

struct Factory {
    let interfaceName: String
    let implementationName: String
    let instanceTypeName: String
    let members: [Member]
    let constructor: SourceryRuntime.Method
    let variables: [Variable]

    enum Error: Swift.Error {
        case noInit(Type)
        case multipleInits(Type)
    }

    init(_ type: Type) throws {
        let constructors = type.methods.filter(Utils.isInjectable).filter { $0.callName == "init" }

        guard !constructors.isEmpty else { throw Factory.Error.noInit(type) }
        guard constructors.count == 1 else { throw Factory.Error.multipleInits(type) }

        self.interfaceName = "Provider<\(type.name)>"
        self.implementationName = "\(type.name)$$Factory"
        self.instanceTypeName = type.name
        self.constructor = constructors[0]
        self.variables = type.variables.filter(Utils.isInjectable)
        self.members = try constructor.parameters.map(Member.init) + variables.map(Member.init)
    }
}
