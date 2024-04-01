//
//  WelcomeView.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack{
            Spacer().frame(height: 50)
            Text("Welcome to Expense App")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.title)
                .padding(.vertical)
            
            Text("Please login to your account or create new account to continue")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink(destination: LoginView()) {
            Text("LOGIN")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                    }
                    .background(Color.purple)
                    .cornerRadius(10)
                    .border(Color.purple, width: 2)
            
            Spacer().frame(height: 16)
            
            NavigationLink(destination: RegisterView()) {
            Text("CREATE ACCOUNT")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                    }
                    .cornerRadius(10)
                    .border(Color.purple, width: 2)
            
            Spacer().frame(height: 25)
            
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WelcomeView()
}
