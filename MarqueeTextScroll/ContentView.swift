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
            Text("Marquee Scroll")
                .fontWeight(.heavy)
                .font(.title)
            Spacer()
            VStack {
                Text("Timer Scroll (drag-able)")
                    .bold()
                TimerMarqueeTextScroll(array: vm.arrayOfThingsToScroll)
            }
            VStack {
                Text("Offset Scroll start / stop")
                    .bold()
                OffsetMarqueeTextScroll(array: vm.arrayOfThingsToScroll)
                Text("Offset Scroll continuous")
                    .bold()
                LoopingOffsetMarqueeTextScroll(array: vm.arrayOfThingsToScroll)
            }
            Spacer()
        }
    }
}


// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


