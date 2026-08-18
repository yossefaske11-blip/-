import Foundation
import SwiftUI
import Combine// 👈 هذا هو السطر الناقص السحري الذي سيحل كل الأخطاء!
import UserNotifications
// هيكل لحفظ البيانات
struct DailyLog: Codable, Identifiable {
    var id = UUID()
    let dateString: String
    let dayName: String
    let monthString: String
    var count: Int
}

// تأكد أن هذه الكلمة مكتوبة تماماً هكذا ومطابقة للبروتوكول
class CountManager: ObservableObject {
    @Published var dailyLogs: [DailyLog] = []
    
    init() {
        loadData()
    }
    
    func logCount() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        
        formatter.dateFormat = "yyyy-MM-dd"
        let todayStr = formatter.string(from: Date())
        
        formatter.dateFormat = "EEEE"
        let dayName = formatter.string(from: Date())
        
        formatter.dateFormat = "yyyy-MM"
        let monthStr = formatter.string(from: Date())
        
        if let index = dailyLogs.firstIndex(where: { $0.dateString == todayStr }) {
            dailyLogs[index].count += 1
        } else {
            let newLog = DailyLog(dateString: todayStr, dayName: dayName, monthString: monthStr, count: 1)
            dailyLogs.append(newLog)
        }
        saveData()
    }
    
    func getCountFor(dayName: String) -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        
        // إذا كان اليوم المُراد هو اليوم الحالي، نعطيه الحسبة المباشرة
        formatter.dateFormat = "EEEE"
        let todayName = formatter.string(from: Date())
        
        let cleanToday = todayName.replacingOccurrences(of: "إ", with: "ا")
        let cleanTarget = dayName.replacingOccurrences(of: "إ", with: "ا")
        
        if cleanToday == cleanTarget {
            formatter.dateFormat = "yyyy-MM-dd"
            let todayStr = formatter.string(from: Date())
            return dailyLogs.firstIndex(where: { $0.dateString == todayStr }).map { dailyLogs[$0].count } ?? 0
        }
        
        // للأيام الأخرى السابقة
        return dailyLogs.filter { $0.dayName.replacingOccurrences(of: "إ", with: "ا") == cleanTarget }.map { $0.count }.reduce(0, +)
    }
    
    func getCurrentMonthTotal() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let currentMonth = formatter.string(from: Date())
        
        return dailyLogs.filter { $0.monthString == currentMonth }.map { $0.count }.reduce(0, +)
    }
    
    func getAllTimeTotal() -> Int {
        return dailyLogs.map { $0.count }.reduce(0, +)
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(dailyLogs) {
            UserDefaults.standard.set(encoded, forKey: "SmartTasbihLogs")
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "SmartTasbihLogs"),
           let decoded = try? JSONDecoder().decode([DailyLog].self, from: data) {
            self.dailyLogs = decoded
        }
    }
    
    
    // دالة لطلب إذن التنبيهات وتفعيلها
   
    // دالة لطلب إذن التنبيهات وتفعيلها
    func requestNotificationPermission(isEnabled: Bool) {
        if isEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    self.scheduleDailyNotifications()
                }
            }
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    // دالة لجدولة رسائل تذكيرية بأصوات بشرية مخصصة
    func scheduleDailyNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // الأذكار المكتوبة التي ستظهر كإشعار على شاشة القفل
        let messages = [
            "﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾ - سبّح وضاعف أجورك 📿",
            "اذكر الله الآن، سبحان الله وبحمده سبحان الله العظيم ✨",
            "صلِّ على النبي ﷺ وافتح كتاب الأذكار اليومية 🌙",
            "لا تنسَ وردك من التسبيح اليومي، العداد بانتظارك 🌴"
        ]
        
        // جدولة التنبيهات
        for i in 1...3 {
            let content = UNMutableNotificationContent()
            content.title = "المسبحة الذكية"
            content.body = messages.randomElement() ?? "اذكر الله"
            
            // ✨ التعديل: ربط التنبيه بملف صوتي بشري مخصص باسم "zikr_voice.wav"
            // يمكنك تسمية الملف الصوتي الذي ستجلبه بأي اسم وتطابقه هنا
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "zikr_voice.wav"))
            
            // التوقيت بالثواني (مثلاً بعد 3 ساعات وتتكرر)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 10800), repeats: true)
            let request = UNNotificationRequest(identifier: "Reminder_\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}
