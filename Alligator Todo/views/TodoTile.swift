//
//  TodoItem.swift
//  Alligator Todo
//
//  Created by Peter G Hayes on 21/08/2023.
//

import SwiftUI
import RiveRuntime

struct TodoTile: View {
    let item: TodoModel
    let onComplete: (_ item: TodoModel) -> Void
    
    @State var currentDragOffsetX: CGFloat = 0
    @State var alligatorDragOffsetX: CGFloat = 0
    @State var endingDragOffsetX: CGFloat = 0
    @State var isCompleted = false;
    
    let screenWidth = UIScreen.main.bounds.width;
    
    
    @StateObject var viewModel = RiveViewModel(fileName: "alligator_swipe", fit: .fitWidth)
    
    let maxDrag = 200.0
    
    let multiplier = 1.9 // This is to make the animation happen faster than the slide
 
    
    func updateAlligator(_ value: Double) {
        viewModel.setInput("scroll", value: value)
    }
    
    func complete() {
        isCompleted = true;
        updateAlligator(100)
        withAnimation(.spring().delay(1)) {
            alligatorDragOffsetX = 0
        } completion: {
            onComplete(item)
        }
    }
    
    var body: some View {
        HStack {
            Text(item.title)
                .foregroundColor(.white)
                .font(.headline)
            Spacer()
        }
        .padding(.all)
        .background(Color("Card"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 3, y: 3)
        
        .padding(.horizontal)
        .offset(x: currentDragOffsetX)
        .offset(x: endingDragOffsetX)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if (isCompleted || value.translation.width < -30) {
                        return
                    }
                    
                    let percentage = value.translation.width / screenWidth * (100 * multiplier) ;
                    
                    updateAlligator(percentage)
                    
                    withAnimation(.spring()) {
                        currentDragOffsetX = value.translation.width
                        alligatorDragOffsetX = value.translation.width * multiplier
                    }
                    
                    if (value.translation.width > maxDrag) {
                        withAnimation(.spring()) {
                            currentDragOffsetX = 0
                            endingDragOffsetX = screenWidth
                            alligatorDragOffsetX = maxDrag * multiplier
                        }
                        complete()
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        currentDragOffsetX = 0
                        if (!isCompleted) {
                            alligatorDragOffsetX = 0
                        }
                        
                    }
                }
        ).overlay
        {
            viewModel.view()
                .frame(width: screenWidth, height: 250)
                .offset(x: 2, y: -25)
                .offset(x: screenWidth - alligatorDragOffsetX)
                .allowsHitTesting(false)
        }
    }
}

struct TodoItem_Previews: PreviewProvider {
    static var previews: some View {
        TodoTile(item: TodoModel(title: "Swipe me"), onComplete: {value in print("delete")})
    }
}
