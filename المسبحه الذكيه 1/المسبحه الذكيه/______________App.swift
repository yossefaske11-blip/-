import SwiftUI

@main
struct AlMasebhaApp: App {
    // قراءة الإعدادات المفضلة للمستخدم لتطبيقها فور تشغيل التطبيق
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"
    @AppStorage("appLanguage") private var appLanguage: String = "ar"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // ✨ تفعيل المظهر المختار (داكن أو فاتح) على كامل التطبيق
                .preferredColorScheme(getSelectedColorScheme())
                // ✨ تفعيل اتجاه اللغة المختار على كامل التطبيق
                .environment(\.layoutDirection, appLanguage == "ar" ? .rightToLeft : .leftToRight)
        }
    }
    
    // دالة ذكية لتحويل النص المحفوظ إلى نوع مظهر تفهمه آبل
    func getSelectedColorScheme() -> ColorScheme? {
        switch appColorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil // يتبع مظهر نظام الهاتف التلقائي
        }
    }
}
