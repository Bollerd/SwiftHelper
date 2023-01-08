import Foundation

public extension Date {
    mutating func setDate(newDate: String, dateFormat: String) {
        let dateFormatter:DateFormatter = DateFormatter()
        
        if dateFormat == ""  {
            dateFormatter.dateFormat = "yyyyMMdd"
        } else {
            dateFormatter.dateFormat = dateFormat
        }
        
        self = dateFormatter.date(from: newDate)!
    }
    
    /// format a date as string in the provided format
    /// - Parameter format: format how the string for the date should be formatted, e.g. dd-MM-YYYY
    /// - Returns: Date as formatted string
    func getFormattedDate(format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if self.month == 1 && self.day == 1 {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
	}
        return dateFormatter.string(from: self)
    }
    
    func getDayOfWeek() -> Int {
        var weekDay = 0
        let todayDate = self
        if let myCalendar = NSCalendar(calendarIdentifier: .gregorian) {
            let myComponents = myCalendar.components(.weekday, from: todayDate as Date)
            weekDay = myComponents.weekday!
        }
        return weekDay
    }
    
    static func getFormattedTimeDifferenceToToday(otherDate: String, dateFormat: String) -> DateComponents {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        
        if dateFormat == "" {
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        } else {
            dateFormatter.dateFormat = dateFormat
        }
        
        let relDate = dateFormatter.date(from: otherDate)
        
        let diffTime = Calendar.current.dateComponents([.hour,.minute,.second,.day,.month], from: todaysDate, to: relDate!)
        return diffTime
    }
    
    static func getDaysDifferenceToToday(otherDate: String, dateFormat: String) -> Int {
        let dateFormatter:DateFormatter = DateFormatter()
        
        if dateFormat == "" {
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        } else {
            dateFormatter.dateFormat = dateFormat
        }
        
        let relDate = dateFormatter.date(from: otherDate)
        
        var timeDifference = Date().timeIntervalSince(relDate!)
        if timeDifference < 0 {
            timeDifference = -timeDifference
        }
        timeDifference = timeDifference / 3600 / 24
        return Int(timeDifference)
    }
    
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    
    static var today: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: Date().noon)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    static func dateAsSAPDate(date: Date) -> String {
        let calendar = NSCalendar.current
        
        let year =  calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var monthString = "00"
        var dayString = "00"
        
        if month < 10 {
            monthString =  "0\(month)"
        } else {
            monthString =  "\(month)"
        }
        
        if day < 10 {
            dayString =  "0\(day)"
        } else {
            dayString =  "\(day)"
        }
        return "\(year)\(monthString)\(dayString)"
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    func getDate(dayDifference: Int) -> Date {
        var components = DateComponents()
        components.day = dayDifference
        return Calendar.current.date(byAdding: components, to:startOfDay)!
    }
    
    static func getFixedTimeAtDate(daysFromToday: Int, atHour: Int, atMinute: Int) -> Date {
        let seconds = Double(daysFromToday * 60 * 60 * 24)
        let now = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let hour = atHour
        let minutes = atMinute
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "\(year)/\(month)/\(day) \(hour):\(minutes)")
       
        if let newDate = someDateTime {
            return newDate
        }else {
            return Date()
        }
    }
    
    static func getFixedTimeAtDate(daysFromToday: Int, atHour: Int, atMinute: Int) -> DateComponents {
        let seconds = Double(daysFromToday * 60 * 60 * 24)
        let now = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let hour = atHour
        let minutes = atMinute
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "\(year)/\(month)/\(day) \(hour):\(minutes)")
       
        if let newDate = someDateTime {
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        }else {
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        }
    }
}

