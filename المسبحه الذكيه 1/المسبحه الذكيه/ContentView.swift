import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    // إنشاء كائن الحفظ الذكي المشترك
    @StateObject private var countManager = CountManager()
    
    // ✨ التعديل: قراءة اللغة المفضلة لتطبيقها تلقائياً على كامل التطبيق دون مِرآة
    @AppStorage("appLanguage") private var appLanguage: String = "ar"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 1. الصفحة الرئيسية (التسبيح)
            MainTasbihView(manager: countManager)
                .tabItem {
                    Label("التسبيح", systemImage: "bolt.heart.fill")
                }
                .tag(0)
            
            // 2. صفحة الأذكار
            AzkarView()
                .tabItem {
                    Label("الأذكار", systemImage: "book.fill")
                }
                .tag(1)
            
            // 3. صفحة المصحف
            QuranView()
                .tabItem {
                    Label("المصحف", systemImage: "book.pages.fill")
                }
                .tag(2)
            
            // 4. صفحة الإحصائيات
            StatsView(manager: countManager)
                .tabItem {
                    Label("الإحصائيات", systemImage: "chart.bar.xaxis")
                }
                .tag(3)
            
            // 5. صفحة الإعدادات
            SettingsView(manager: countManager)
                .tabItem {
                    Label("الإعدادات", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(.blue) // اللون الموحد للأيقونات النشطة
        // ✨ مكان السطر الصحيح: يتم ربطه بعد نهاية قوس الـ TabView لإعادة توجيه اللغة بسلاسة
        .environment(\.locale, Locale(identifier: appLanguage))
    }
}

#Preview {
    ContentView()
}
