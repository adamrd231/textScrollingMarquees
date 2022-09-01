//
//  ContentView.swift
//  MarqueeTextScroll
//
//  Created by Adam Reed on 9/1/22.
//

import SwiftUI

class ContentViewViewModel: ObservableObject {
    var arrayOfThingsToScroll = ["Frodo", "Samwise", "Merry", "Pippen", "Gandalf", "Legolas", "Aragorn", "Gimli"]
}

struct ContentView: View {
    
    @StateObject var vm = ContentViewViewModel()

    var body: some View {
        // Using Timer to capture offset
        // -> Benefit of using the timer to move the ticker is you can disable the timer when a user drags on the Marquee to look at more information
        VStack {
            TimerMarqueeTextScroll(array: vm.arrayOfThingsToScroll)
            Divider()
            OffsetMarqueeTextScroll(array: vm.arrayOfThingsToScroll)
        }
       
        
    }
}

struct OffsetMarqueeTextScroll: View {
    
    var array: [String]
    
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
                withAnimation(.linear(duration: 10).repeatForever()) {
                    offsetToScrollTo = newSize.width * -1
                }
                
            }
        }
        .foregroundColor(.white)
        .background(Color.blue)
    }
}


struct TimerMarqueeTextScroll: View {
    var array: [String]
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
            .padding()
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


// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
 
}

private struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
