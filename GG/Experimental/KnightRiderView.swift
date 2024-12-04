//
//  KnightRiderView.swift
//  GG
//
//  Created by Vito Royeca on 12/4/24.
//

import SwiftUI

import Combine
import SwiftUI

enum AnimationStatus {
    case start(index:Int)
    case stop(index:Int)
    case stopAll
}

struct KnightRiderRect: View {
    
    var index:Int
    var publisher:PassthroughSubject<AnimationStatus, Never>
    
    @State private var animate = false
    
    var body: some View {
        Rectangle()
            .foregroundColor(Color.red)
            .opacity(animate ? 1 : 0.2)
            .frame(width:40, height:40)
            .padding(.all, 5)
            .animation(Animation.linear(duration: 0.3))
            .onReceive(publisher) { value in
                switch value {
                case .start(let index):
                    if index == self.index {
                        self.animate = true
                    }
                    else {
                        self.animate = false
                    }
                case .stop(let index):
                    if index == self.index {
                        self.animate = false
                    }
                case .stopAll:
                    self.animate = false
                }
                
            }
    }
}

struct KnightRiderView: View {
    
    @State private var increment = true
    @State private var currentIndex = 0
    @State private var publisher = PassthroughSubject<AnimationStatus, Never>()
    
    var body: some View {
        HStack {
            KnightRiderRect(index:0, publisher:publisher)
            KnightRiderRect(index:1, publisher:publisher)
            KnightRiderRect(index:2, publisher:publisher)
            KnightRiderRect(index:3, publisher:publisher)
            KnightRiderRect(index:4, publisher:publisher)
            KnightRiderRect(index:5, publisher:publisher)
        }
        .background(Color.black)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
                if self.increment {
                    if self.currentIndex > 5 {
                        self.increment = false
                        self.currentIndex = 5
                        self.publisher.send(.stopAll)
                    }
                    else {
                        self.publisher.send(.start(index: self.currentIndex))
                        self.currentIndex += 1
                    }
                }
                else {
                    if self.currentIndex < 0 {
                        self.increment = true
                        self.currentIndex = 0
                        self.publisher.send(.stopAll)
                    }
                    else {
                        self.publisher.send(.start(index: self.currentIndex))
                        self.currentIndex -= 1
                    }
                }
            }
        }
    }
}

#Preview {
    KnightRiderView()
}
