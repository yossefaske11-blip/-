import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager: CountManager
    
    @AppStorage("username") private var username: String = "Your Name"
    @AppStorage("isHapticsEnabled") private var isHapticsEnabled: Bool = true
    @AppStorage("dailyGoalValue") private var dailyGoalValue: Int = 100
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled: Bool = false
    @State private var showLanguageAlert = false

    // إعدادات المظهر واللغة
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"
    @AppStorage("appLanguage") private var appLanguage: String = "ar"
    
    @State private var newName: String = ""
    @State private var showSaveToast = false
    
    // 💡 دالة الترجمة السحرية المستقيمة لمنع المِرآة وانعكاس الشاشة
    func localize(ar: String, en: String) -> String {
        return appLanguage == "ar" ? ar : en
    }
    
    var body: some View {
        NavigationView {
            Form {
                // 1️⃣ قسم الملف الشخصي
                Section(header: Text(localize(ar: "الملف الشخصي", en: "Profile"))) {
                    HStack {
                        TextField(localize(ar: "عدّل اسمك هنا...", en: "Edit your name..."), text: $newName)
                            .onAppear {
                                if newName.isEmpty { newName = username }
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            if !newName.trimmingCharacters(in: .whitespaces).isEmpty {
                                username = newName
                                showSaveToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showSaveToast = false
                                }
                            }
                        }) {
                            Text(localize(ar: "حفظ", en: "Save"))
                                .fontWeight(.bold)
                        }
                    }
                    
                    if showSaveToast {
                        Text(localize(ar: "تم تحديث الاسم بنجاح ✨", en: "Name updated successfully ✨"))
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                // 2️⃣ قسم إعدادات التطبيق والمظهر
                Section(header: Text(localize(ar: "إعدادات التطبيق", en: "App Settings"))) {
                    
                    // زر التنبيهات الجديد التفاعلي
                    Toggle(isOn: $isNotificationsEnabled) {
                        Text(localize(ar: "تفعيل رسائل التذكير والبهجة", en: "Enable Reminders"))
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .onChange(of: isNotificationsEnabled) { newValue in
                        manager.requestNotificationPermission(isEnabled: newValue)
                    }
                    
                    Toggle(isOn: $isHapticsEnabled) {
                        Text(localize(ar: "اهتزاز الهاتف عند التسبيح", en: "Haptic Feedback"))
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Picker(localize(ar: "الهدف اليومي للهدية", en: "Daily Goal"), selection: $dailyGoalValue) {
                        Text("33").tag(33)
                        Text("100").tag(100)
                        Text("500").tag(500)
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                    
                    Picker(localize(ar: "مظهر التطبيق", en: "App Appearance"), selection: $appColorScheme) {
                        Text(localize(ar: "تلقائي (النظام)", en: "System")).tag("system")
                        Text(localize(ar: "فاتح", en: "Light")).tag("light")
                        Text(localize(ar: "داكن", en: "Dark")).tag("dark")
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                    
                  

                    // استبدل بيكر اللغة القديم بهذا:
                    Picker(localize(ar: "لغة التطبيق", en: "Language"), selection: $appLanguage) {
                        Text("العربية").tag("ar")
                        Text("English").tag("en")
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                    .onChange(of: appLanguage) { _ in
                        showLanguageAlert = true
                    }
                    // أضف هذا التنبيه في أسفل الـ Form
                    .alert(isPresented: $showLanguageAlert) {
                        Alert(
                            title: Text(localize(ar: "تغيير لغة التطبيق", en: "Change Language")),
                            message: Text(localize(ar: "يرجى إغلاق التطبيق وإعادة فتحه لتطبيق اللغة الجديدة بشكل صحيح ومستقيم وبدون أي بطء.", en: "Please restart the app to apply the new language correctly and smoothly.")),
                            dismissButton: .default(Text(localize(ar: "حسناً", en: "OK")))
                        )
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                }
                
                // 3️⃣ قسم الدعم والمشاركة
                Section(header: Text(localize(ar: "عن التطبيق", en: "About App"))) {
                    Button(action: {
                        let shareText = localize(
                            ar: "أوصيك بتحميل تطبيق 'المسبحة الذكية' لمساعدتك على الأذكار والتسبيح اليومي ومتابعة حصادك الإيماني! 📿✨",
                            en: "I recommend downloading 'Smart Tasbih' app for daily Azkar, praises, and tracking your spiritual progress! 📿✨"
                        )
                        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            rootVC.present(activityVC, animated: true, completion: nil)
                        }
                    }) {
                        HStack {
                            Text(localize(ar: "مشاركة التطبيق مع الأصدقاء", en: "Share App with Friends"))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle(localize(ar: "الإعدادات", en: "Settings"))
            // تم إزالة قيد اتجاه البيئة اليدوي لمنع المِرآة تماماً ولتستقيم الكلمات بصرياً
        }
    }
}
