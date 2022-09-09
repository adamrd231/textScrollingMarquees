//
//  TimerMarqueeScroller.swift
//  MarqueeTextScroll
//
//  Created by Adam Reed on 9/1/22.
//

import SwiftUI

struct TimerMarqueeTextScroll: View {
    let array: [String]
    @State var viewWidth = 1.0
    @State var moveToggle = true
    @State var counter: Int64 = 0
    @State var isDragging = false
    @State var dragDistance: Int64 = 0

    var valueToOffsetTo: Double {
        let offset = (counter + dragDistance).quotientAndRemainder(dividingBy: Int64(viewWidth)).remainder
        print("offset: \(offset)")
        let absOffset = abs(offset)
        return Double(absOffset)
    }
    
    let timer = Timer.publish(every: 0.0333, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(array, id: \.self) { thing in
                    Text(thing)
                        .padding()
                    
                }
            }
            .background(Color(.darkGray))
            .foregroundColor(.white)
            .fixedSize()
            .offset(x: -valueToOffsetTo)
            .offset(x: moveToggle ?  0 : valueToOffsetTo)
            HStack {
                ForEach(array, id: \.self) { thing in
                    Text(thing)
                        .padding()
                }
            }
            .fixedSize()

            .readSize { newSize in
                print("What is our view width: \(newSize)")
                viewWidth = newSize.width
            }
            .offset(x: -valueToOffsetTo + viewWidth)
            //.offset(x: moveToggle ? valueToOffsetTo : valueToOffsetTo * 2)

        }
        .background(Color(.darkGray))
        .foregroundColor(.white)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    isDragging = true
                    dragDistance = -Int64(gesture.translation.width)
                }
                .onEnded { _ in
                    isDragging = false
                    counter += dragDistance
                    
                }
        )

        .onReceive(timer) { _ in
            print(".")
            guard !isDragging else { return }
            // overly cautious. doubt the phone would lat 10 trillion days
            if counter > (Int64.max - 100) { counter = 0 }
            if counter < Int64.min + 100 { counter = 0}
            dragDistance = 0
            counter += 3
          
        }
    }
}




struct TimerMarqueeTextScroll_Previews: PreviewProvider {
    static var previews: some View {
        TimerMarqueeTextScroll(array: ["11", "22", "33"])
    }
}
