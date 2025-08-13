import SwiftUI
import CodeScanner

struct CustomAppBar: View {
    var userName: String
    @State private var animate = false
    @State private var isShowingScanner = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                     Text(getGreeting())
                         .font(.subheadline)
                         .foregroundColor(.gray)
                     
                     Spacer()
                Button(action: {
                                    isShowingScanner = true
                    
                    
                                }) {
                                    Image(systemName: "qrcode.viewfinder")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                .accessibilityLabel("Open QR Scanner")                 }
            // Name
            Text(userName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)

            // Date and Notification Icon
            HStack {
                Text(getCurrentDate())
                    .font(.system(size: 13))
                    .foregroundColor(.black)
                    .fontWeight(.medium)

                Spacer()

                // Wrap Location + Lightning in a ZStack
                ZStack {
                    LocationWidget()

                    
                }
            }
        }
        
        .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], completion: handleScan)
                }
    }

    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        return dateFormatter.string(from: Date())
    }
    private func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            print("Scanned QR code: \(scanResult.string)")
            // You can access scanResult.string for the scanned content
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Good Night"
        }
    }
}


struct LocationWidget: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .foregroundColor(.white)

            Text("West Jakarta")
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue)
        .cornerRadius(30)
    }
}
