//
//  TodoList.swift
//  Alligator Todo
//
//  Created by Peter G Hayes on 21/08/2023.
//

import SwiftUI


extension Color {
    static let backgroundBottom = Color("BackgroundBottom")
    static let backgroundTop = Color("BackgroundTop")
    static let backgroundMiddle = Color("BackgroundMiddle")
    static let darkCard = Color("DarkCard")
}

struct TodoList: View {
    @State private var todoItems: [TodoModel] = [
        TodoModel(title: "Go swimming"),
        TodoModel(title: "Make a todo list app"),
        TodoModel(title: "Experiment with Rive")]
    @State private var newItemTitle: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Text("Chomping Chores")
                    .foregroundColor(.accentColor)
                    .font(Font.largeTitle .weight(.bold))
                
                Text("Scale the day")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.subheadline)
                
                HStack {
                    TextField("", text: $newItemTitle, onCommit: addItem)
                        .frame(height: 55)
                        .padding(.horizontal)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.headline.weight(.medium))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2)))
                        .padding()
                     
                    Button(action: addItem) {
                        Text("Add")
                            .foregroundColor(.accentColor)
                            .font(.headline.bold())
                            .padding(.trailing)
                    }
                    
                }
                
            }
            .padding(8)
            .background(Color("DarkCard").opacity(0.8))
            .cornerRadius(16)
            .padding()
            
            ScrollView {
                ForEach(todoItems) { item in
                    TodoTile(item: item, onComplete: deleteItem).padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                }
            }.scrollClipDisabled()
        }.background(
            LinearGradient(gradient: Gradient(colors: [.backgroundTop, .backgroundMiddle,  .backgroundBottom]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    func addItem() {
        if !newItemTitle.isEmpty {
            let newItem = TodoModel(title: newItemTitle)
            todoItems.append(newItem)
            newItemTitle = ""
        }
    }
    
    func deleteItem(item: TodoModel) {
        if let index = todoItems.firstIndex(where: {a in a.id == item.id}) {
            todoItems.remove(at: index)
        }
        
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList()
    }
}
