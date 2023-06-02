import Foundation
import UIKit

let rubik = "Rubik"
let roboto = "Roboto"

enum AppFont: String {
    case light = "Light"
    case regular = "Regular"
    case bold = "Bold"
    case medium = "Medium"
    case black = "B"

    func size(_ size: CGFloat, family_Name: String = rubik) -> UIFont {
        if let font = UIFont(name: family_Name, size: size + 1.0) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }

    fileprivate var fullFontName: String {
        return rawValue.isEmpty ? rubik : rubik + "-" + rawValue
    }
}
