//
//  TodoModel.swift
//  Alligator Todo
//
//  Created by Peter G Hayes on 21/08/2023.
//

import SwiftUI

struct TodoModel: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
