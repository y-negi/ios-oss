// swiftlint:disable force_unwrapping
import Foundation
import XCTest
import ColorScriptCore
import ColorScript

final class ColorScriptTests: XCTestCase {

  let json = """
          {
            "apricot_600": "FFCBA9",
            "cobalt_500": "4C6CF8",
            "dark_grey_400": "9B9E9E",
            "dark_grey_500": "656868"
          }
          """

  func testDataNil_InvalidJSON() {
    let invalidJson = """
          {
            "dark_grey_400": "9B9E9E",
            "dark_grey_500": true
          }
          """
    let data = invalidJson.data(using: .utf8)!
    let colors = Color(data: data)
    XCTAssertNil(colors.colors())
  }

  func testDataIsNotNil_ValidJSON() {
    let data = json.data(using: .utf8)!
    let colors = Color(data: data)
    XCTAssertNotNil(colors.colors())
  }

  func testColorNameFormat() {

    let data = json.data(using: .utf8)!
    let colors = Color(data: data)
    colors.allColors.forEach { (arg: (key: String, value: [(key: Int, value: String)])) in

      let (key, value) = arg
      let colorName = key.lowercased()
      let weight = value.first!.key
      let formattedName = weight > 0 ? "ksr_\(colorName.replacingOccurrences(of: " ", with: "_"))_\(weight)" :
                                       "ksr_\(colorName.replacingOccurrences(of: " ", with: "_"))"

      XCTAssertEqual(
        value.first?.value, formattedName
      )
    }
  }

  func testAutogeneratedOutput() {

    let json = """
          {
            "apricot_600": "FFCBA9"
          }
          """
    let data = json.data(using: .utf8)!
    let colors = Color(data: data)

    let output = """
                 //===============================================================
                 //
                 // This file is computer generated from Colors.json. Do not edit.
                 //
                 //===============================================================

                 import UIKit

                 // swiftlint:disable valid_docs
                 extension UIColor {
                   public static var ksr_allColors: [String: [Int: UIColor]] {
                     return [
                       "Apricot": [
                         600: .ksr_apricot_600
                       ]
                     ]
                   }

                   /// 0xFFCBA9
                   public static var ksr_apricot_600: UIColor {
                     return .hex(0xFFCBA9)
                   }
                 }

                 """
    XCTAssertEqual(output, colors.staticStringsLines().joined(separator: "\n"))
  }

  static var allTests = [
      ("testDataIsNotNil_ValidJSON", testDataIsNotNil_ValidJSON),
      ("testDataNil_InvalidJSON", testDataNil_InvalidJSON),
      ("testColorNameFormat", testColorNameFormat)
  ]
}
