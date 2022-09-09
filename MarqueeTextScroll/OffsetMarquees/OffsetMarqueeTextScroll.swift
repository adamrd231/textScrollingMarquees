//
//  OffsetMarqueeTextScroll.swift
//  MarqueeTextScroll
//
//  Created by Adam Reed on 9/1/22.
//

import SwiftUI

struct OffsetMarqueeTextScroll: View {
    
    let array: [String]
    
    @State var offsetToScrollTo = UIScreen.main.bounds.width
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(array, id: \.self) { item in
                    Text(item)
                        .fontWeight(.heavy)
                        .padding()
                }
            }
            
            .offset(x: offsetToScrollTo)
            .readSize { newSize in
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    offsetToScrollTo = newSize.width * -1
                }
                
            }
        }
        .disabled(true)
        .foregroundColor(.white)
        .background(Color.blue)
    }
}


struct OffsetMarqueeTextScroll_Previews: PreviewProvider {
    static var previews: some View {
        OffsetMarqueeTextScroll(array: ["1", "2", "3"])
    }
}
