//
//  HomeView.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showModal = false
    @ObservedObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack(alignment: .trailing){
            Button("Logout"){
                authViewModel.logoutUser()
            }
            Spacer().frame(height: 50)
            HStack{
                Text("Tap + to add a expense")
                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: {
                    showModal = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(4)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Circle())
                    
                }.sheet(isPresented: $showModal){
                    ModalView(homeViewModel: homeViewModel)
                }
            }
            Group{
                if homeViewModel.expenses.isEmpty{
                    VStack{
                        Spacer()
                            Image("NoItemsListImage")
                                .scaledToFit()
                                .frame(width: 200,height: 200)
                        Spacer().frame(height: 8)
                        Text("What are your expenses for today?")
                            .font(.subheadline)
                        Spacer()
                    }.frame(maxWidth: .infinity)
                        
                }else{
                    List(homeViewModel.expenses) { expense in
                                ItemExpenseView(
                                    expense: expense,
                                    homeViewModel: homeViewModel)
                    }
                }
            }
            Spacer().frame(height: 25)
        }
        .onAppear{
            homeViewModel.fetchExpenses(userId: authViewModel.loggedUser!.uid)
        }
        .padding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

struct ItemExpenseView: View{
    @State private var showAlertDeleteExpenseModal = false
    var expense: ExpenseModel
    var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(expense.title)
                    .font(.headline)
                Spacer()

                Button(action: {
                    showAlertDeleteExpenseModal = true
                }){
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundColor(.red)
                        
                }
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showAlertDeleteExpenseModal){
                    Alert(title: Text("Confirmation"),message: Text("Do you wish to delete this item?"),
                          primaryButton: .default(Text("OK")){
                        homeViewModel.deleteExpense(expense: expense, userId: authViewModel.loggedUser!.uid)
                        
                    }, secondaryButton: .cancel(Text("Cancel")))
                }
            }
            Spacer().frame(height: 8)
            Text(expense.description)
                .font(.subheadline)
        }
        .padding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    @State private var title: String = ""
    @State private var description: String = ""
    @State var showAlert = false
    @State var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                Text("Description")
                    .foregroundColor(.gray)
                    .font(.body)
                    .padding(.top, 8)
                
                TextEditor(text: $description)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.bottom, 8)
            }
            .navigationBarItems(trailing: Button("Add") {
                if(title.isEmpty || description.isEmpty) {
                    alertMessage = "Error in add expense"
                    showAlert = true
                    return
                }
                homeViewModel.addExpense(title: title, description: description, userId: authViewModel.loggedUser!.uid)
                presentationMode.wrappedValue.dismiss()
                
            })
            .navigationBarTitle("Add Expense", displayMode: .inline)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warning"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
        .padding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    HomeView()
}
