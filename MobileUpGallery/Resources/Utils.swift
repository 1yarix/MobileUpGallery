import Foundation

class Utils {
    
    static func formatDate(unformatted: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: unformatted)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM y"
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }
}
