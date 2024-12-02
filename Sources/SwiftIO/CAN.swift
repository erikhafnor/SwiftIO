import CSwiftIO
import SwiftIO

public final class CAN {
    private let id: Int32
    @_spi(SwiftIOPrivate) public let obj: UnsafeMutableRawPointer

    private var baudRate: Int {
        willSet {
            setBaudRate(newValue)
        }
    }

    public init(_ idName: Id, baudRate: Int = 500000) {
        self.id = idName.rawValue
        self.baudRate = baudRate

        if let ptr = swifthal_can_open(Int(id)) {
            obj = ptr
        } else {
            print("error: CAN \(id) init failed!")
            fatalError()
        }

        setBaudRate(baudRate)
    }

    deinit {
        swifthal_can_close(obj)
    }

    @discardableResult
    public func setBaudRate(_ baudRate: Int) -> Result<(), Errno> {
        let result = nothingOrErrno(
            swifthal_can_baudrate_set(obj, ssize_t(baudRate))
        )

        if case .failure(let err) = result {
            let errDescription = err.description
            print("error: \(self).\(#function) line \(#line) -> " + errDescription)
        }

        return result
    }

    @discardableResult
    public func write(_ message: CANMessage) -> Result<(), Errno> {
        let result = nothingOrErrno(
            swifthal_can_write(obj, message.id, message.data, ssize_t(message.data.count))
        )

        if case .failure(let err) = result {
            let errDescription = err.description
            print("error: \(self).\(#function) line \(#line) -> " + errDescription)
        }

        return result
    }

    public func read() -> CANMessage? {
        var id: UInt32 = 0
        var data = [UInt8](repeating: 0, count: 8)
        let result = valueOrErrno(
            swifthal_can_read(obj, &id, &data, ssize_t(data.count))
        )

        if case .success(let count) = result {
            return CANMessage(id: id, data: Array(data.prefix(count)))
        } else if case .failure(let err) = result {
            let errDescription = err.description
            print("error: \(self).\(#function) line \(#line) -> " + errDescription)
        }

        return nil
    }
}
