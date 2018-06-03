@testable import Stiletto
import SourceryRuntime

let typeA = Type(
    name: "A",
    methods: [Method(name: "init", annotations: ["Inject": NSObject()])]
)

let typeB = Type(
    name: "B",
    methods: [Method(
        name: "init",
        parameters: [MethodParameter(typeName: TypeName(typeA.name), type: typeA)],
        annotations: ["Inject": NSObject()]
    )]
)

let typeC = Type(
    name: "C",
    methods: [Method(
        name: "init",
        parameters: [MethodParameter(typeName: TypeName(typeB.name), type: typeB)],
        annotations: ["Inject": NSObject()]
    )]
)

let typeD = Type(
    name: "D",
    methods: [Method(
        name: "init",
        parameters: [
            MethodParameter(typeName: TypeName(typeB.name), type: typeB),
            MethodParameter(typeName: TypeName(typeC.name), type: typeC)
        ],
        annotations: ["Inject": NSObject()]
    )]
)
