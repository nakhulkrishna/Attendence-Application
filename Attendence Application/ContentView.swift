//
//  ContentView.swift
//  Attendece
//
//  Created by Nakhul Krishna on 05/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var navigate = false
    var body: some View {
        NavigationStack{
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Custom App Bar
                        CustomAppBar(userName: "Nakhul Krishna")
                        
                        // Check-in/out Status
                        VStack(spacing: 16) {
                            HStack {
                                CheckinStatus(iconName: "circle-arrow-3", label: "Check In", subLabel: "Early", time: "8:30")
                                CheckinStatus(iconName: "circle-arrow-2", label: "Check Out", subLabel: "Early left", time: "4:30")
                            }
                            
                            HStack {
                                CheckinStatus(isDayAvailable: true, iconName: "delete-button", label: "Absent", subLabel: "Aug", time: "0")
                                CheckinStatus(isDayAvailable: true, iconName: "circle-arrow", label: "Total Days", subLabel: "Aug", time: "6")
                            }
                        }
                        
                        // Attendance History Header
                        HStack(alignment: .bottom) {
                            Text("Attendance History")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                navigate = true
                                print("See More tapped")
                            }) {
                                Text("See More")
                                    .font(.system(size: 15))
                                    .foregroundColor(.blue)
                            }
                            
                        }
                        
                        // Loading animation or content
                        if isLoading {
                            // 🌀 Loading spinner
                            VStack(spacing: 12) {
                                ForEach(0..<3) { _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 80)
                                        .shimmer() // Optional: use shimmer modifier (see below)
                                }
                            }
                            .transition(.opacity)
                        } else {
                            // 🎯 Actual content
                            LazyVStack(spacing: 16) {
                                ForEach(0..<7) { index in
                                    AttendecneHistory()
                                        .transition(.move(edge: .bottom).combined(with: .opacity))
                                        .animation(.easeInOut(duration: 0.3), value: isLoading)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                // Simulate loading for 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
            .navigationDestination(isPresented: $navigate) {
                AttendanceHistoryList()
            }
        }
    }
}

#Preview {
    ContentView()
}
extension View {
    func shimmer() -> some View {
        self
            .overlay(
                ShimmerView()
                    .mask(self)
            )
    }
}

struct ShimmerView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.6), .clear]),
                       startPoint: .leading,
                       endPoint: .trailing)
            .rotationEffect(.degrees(30))
            .offset(x: phase)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 350
                }
            }
    }
}

struct CheckinStatus: View {
    var isDayAvailable: Bool = false
    var iconName: String
    var label: String
    var subLabel: String
    var time: String
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.1))
            .frame(width: .infinity, height: 100)
            .overlay(
                VStack (alignment: .leading){
                    HStack {
                        Image(iconName)
                            .resizable()
                            .frame(width: 25, height: 25)
                       
                        VStack (alignment: .leading){
                            Text(label)
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .bold()
                            
                            Text(subLabel)
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .bold()
                        }
                        Spacer()
                        
                    }
                    Spacer()
                    
                    HStack {
                        Text(time)
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                            .bold()

                        if !isDayAvailable {
                            Color.clear.frame(width: 50, height: 30) // acts like a SizedBox
                        } else {
                            Text("Day")
                        }
                    }

                }.padding()
                
            )
    }
}

struct AttendecneHistory: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.1))
            .frame(maxWidth: .infinity, minHeight: 110, maxHeight: 110)
            .overlay(
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue) // Replace 'Color.b' with actual color
                        .frame(width: 80)
                        .overlay(
                            VStack {
                                Text("22")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Text("Wed")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                
                            }
                        )
                        .padding(8)
                    
                    
                    Spacer()
                    VStack {
                        Text("9:30")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Text("Check In")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                        
                    }
                    Spacer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 1)
                        .padding(.vertical, 15) // optional spacing around the line
                    Spacer()
                    VStack {
                        Text("4:30")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Text("Check Out")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                        
                    }
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 1)
                        .padding(.vertical, 15) // optional spacing around the line
                    Spacer()
                    VStack {
                        Text("8:03")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Text("Total hours")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                        
                    }
                    Spacer()
                    
                }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
    }
}
