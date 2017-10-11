//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit

// MARK: Validators

func checkPath(type: String, assertion: @escaping (Path) -> Bool) -> ((Path) throws -> Path) {
  return { (path: Path) throws -> Path in
    guard assertion(path) else { throw ArgumentError.invalidType(value: path.description, type: type, argument: nil) }
    return path
  }
}

typealias PathValidator = ([Path]) throws -> ([Path])
let pathsExist: PathValidator = { paths in try paths.map(checkPath(type: "path") { $0.exists }) }
let filesExist: PathValidator = { paths in try paths.map(checkPath(type: "file") { $0.isFile }) }
let dirsExist: PathValidator = { paths in try paths.map(checkPath(type: "directory") { $0.isDirectory }) }

// MARK: Path as Input Argument

extension Path: ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.missingValue(argument: nil)
    }
    self = Path(path)
  }
}
