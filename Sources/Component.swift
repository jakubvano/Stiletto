import SourceryRuntime

struct Component {
    let implementationName: String
    let interfaceName: String
    let members: [Member]

    init(_ protocol: Protocol) {
        implementationName = ""
        interfaceName = ""
        members = []
    }
}
