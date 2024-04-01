//
//  ContentView.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        Group{
            if authViewModel.isLoggedIn{
                HomeView()
            }else{
                WelcomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
