import SwiftUI

struct AttendanceHistoryList: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<7) { index in
                    AttendecneHistory()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: index)
                }
            }
            .padding()
        }
    }
}
