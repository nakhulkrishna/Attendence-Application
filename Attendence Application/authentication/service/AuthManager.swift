
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

import Foundation


struct Employee: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var contactNumber: String
    var employeeId: String
}


class AuthManager {
    static let shared = AuthManager()

    private init() {}

    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func isInOffice(userLocation: CLLocation, officeLat: Double, officeLong: Double, radius: Double = 50) -> Bool {
        let officeLocation = CLLocation(latitude: officeLat, longitude: officeLong)
        return userLocation.distance(from: officeLocation) <= radius
    }
}

class AttendanceManager {
    func getAttendanceStatus(startTime: String, endTime: String, lateThreshold: Int, earlyLeaveThreshold: Int) -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let start = formatter.date(from: startTime),
              let end = formatter.date(from: endTime) else {
            return "On Time"
        }
        
        if now > start.addingTimeInterval(TimeInterval(lateThreshold * 60)) && now < end {
            return "Late"
        } else if now < end.addingTimeInterval(TimeInterval(-earlyLeaveThreshold * 60)) {
            return "Early Leave"
        }
        return "On Time"
    }
    
    func markAttendance(employee: Employee, status: String) {
        let db = Firestore.firestore()
        let docId = "\(employee.id)_\(Date().timeIntervalSince1970)"
        
        db.collection("attendance").document(docId).setData([
            "employeeId": employee.id,
            "name": employee.name,
            "status": status,
            "date": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("❌ Error saving attendance: \(error)")
            } else {
                print("✅ Attendance saved")
            }
        }
    }
}





