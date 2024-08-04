//
//  CurrentUser.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 1. 8. 2024..
//
import SwiftUI
import Combine

class CurrentUser: ObservableObject {
    @Published var logged_user: User?

    init(user: User? = nil) {
        self.logged_user = user
    }
}
