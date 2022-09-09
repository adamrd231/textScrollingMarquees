//
//  LoopingOffsetMarqueeTextScroll.swift
//  MarqueeTextScroll
//
//  Created by Adam Reed on 9/1/22.
//

import SwiftUI

struct LoopingOffsetMarqueeTextScroll: View {
    let array: [String]
    
    @State var offsetToScrollTo = 0.0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(array, id: \.self) { item in
                    Text(item)
                        .fontWeight(.heavy)
                        .padding()
                }
                ForEach(array, id: \.self) { item in
                    Text(item)
                        .fontWeight(.heavy)
                        .padding()
                }
            }
            
            .offset(x: offsetToScrollTo)
            .readSize { newSize in
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    offsetToScrollTo = (newSize.width * 0.5) * -1
                }
                
            }
        }
        .disabled(true)
        .foregroundColor(.white)
        .background(Color.purple)
    }
    
}

struct LoopingOffsetMarqueeTextScroll_Previews: PreviewProvider {
    static var previews: some View {
        LoopingOffsetMarqueeTextScroll(array: [])
    }
}
