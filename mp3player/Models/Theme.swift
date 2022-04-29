//
//  Theme.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case light
    case dark
//    case custom

    var accentColor: Color {
        switch self {
        case .light: return Color.bgColor
        case .dark: return Color.textColor
//        case .custom:
//
        }
    }

//    func changeTheme(type:String)->Color{
//        switch type {
//        case .light: return Color.bgColor
//        case .dark: return Color.textColor
    ////        case .custom:
    ////

//    }

    var mainColor: Color {
        Color(rawValue)
    }

    var name: String {
        rawValue.capitalized
    }

    var id: String {
        name
    }
}

extension Color {
    static let bgColor =  Color("BgColor")
    static let textColor = Color("TextColor")
}
