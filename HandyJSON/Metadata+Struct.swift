public extension Metadata {
    public struct Struct : NominalType {
        public static let kind: Kind? = .struct
        public var pointer: UnsafePointer<_Metadata._Struct>
        public var nominalTypeDescriptorOffsetLocation: Int {
            return 1
        }
    }
}

public extension _Metadata {
    struct _Struct {
        var kind: Int
        var nominalTypeDescriptorOffset: Int
        var parent: Metadata?
    }
}
