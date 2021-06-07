//
//  SUIView.swift
//  SetGame
//
//  Created by Joel Cranston on 7/11/20.
//  Copyright © 2020 Joel Cranston. All rights reserved.
//

import SwiftUI

struct SUIView: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Button1")
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Button2")
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Button3")
                }
            }
        }
    }
}
#if DEBUG
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SUIView()
    }
}
#endif
