//=== Utils.swift ---------------------------------------------------------===//
//
// Copyright (c) MadMachine Limited
// Licensed under MIT License
//
// Authors: Andy Liu
// Created: 12/08/2021
//
// See https://madmachine.io for more information
//
//===----------------------------------------------------------------------===//

import CSwiftIO

@inlinable
internal func getClassPointer<T: AnyObject>(_ obj: T) -> UnsafeRawPointer {
  return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

internal func system_strerror(_ __errnum: Int32) -> UnsafeMutablePointer<Int8>! {
  strerror(__errnum)
}



// @_cdecl("posix_memalign")
// public func posix_memalign(ptr: UnsafeMutablePointer<UnsafeMutableRawPointer?>, alignment: Int, size: Int) -> CInt {
//   ptr.pointee = memalign(alignment, size)

//   if ptr.pointee != nil {
//     return 0
//   } else {
//     return -1
//   }
// }

// @_cdecl("getentropy")
// public func getentropy(buffer: UnsafeMutablePointer<UnsafeMutableRawPointer?>, size: Int) -> CInt {
//   z_impl_sys_rand_get(buffer, size)
//   return 0
// }


@inlinable
public func valueOrErrno<D>(
  _ data: D, _ ret: CInt
) -> Result<D, Errno> {
  ret < 0 ? .failure(Errno(ret)) : .success(data)
}

@inlinable
public func valueOrErrno(
  _ ret: CInt
) -> Result<Int, Errno> {
  ret < 0 ? .failure(Errno(ret)) : .success(Int(ret))
}

@inlinable
public func nothingOrErrno(
  _ ret: CInt
) -> Result<(), Errno> {
  valueOrErrno(ret).map { _ in () }
}

// @inlinable
// internal func validateLength(_ array: [UInt8], count: Int?, length: inout Int) -> Result<(), Errno> {
//     if let count = count {
//         if count > array.count || count < 0 {
//             return .failure(Errno.invalidArgument)
//         } else {
//             length = count
//         }
//     } else {
//         length = array.count
//     }

//     return .success(())
// }

@inlinable
internal func validateLength<Element: BinaryInteger>(
  _ array: [Element], count: Int?, length: inout Int
) -> Result<(), Errno> {
  if let count = count {
    if count > array.count || count < 0 {
      return .failure(Errno.invalidArgument)
    } else {
      length = count * MemoryLayout<Element>.stride
    }
  } else {
    length = array.count * MemoryLayout<Element>.stride
  }

  return .success(())
}

@inlinable
internal func validateLength(
  _ buffer: UnsafeMutableRawBufferPointer, count: Int?, length: inout Int
) -> Result<(), Errno> {
  if let count = count {
    if count > buffer.count || count < 0 {
      return .failure(Errno.invalidArgument)
    } else {
      length = count
    }
  } else {
    length = buffer.count
  }

  return .success(())
}

@inlinable
internal func validateLength(_ buffer: UnsafeRawBufferPointer, count: Int?, length: inout Int)
  -> Result<(), Errno>
{
  if let count = count {
    if count > buffer.count || count < 0 {
      return .failure(Errno.invalidArgument)
    } else {
      length = count
    }
  } else {
    length = buffer.count
  }

  return .success(())
}
