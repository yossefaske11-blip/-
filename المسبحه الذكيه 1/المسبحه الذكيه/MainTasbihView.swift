import SwiftUI

struct MainTasbihView: View {
    @ObservedObject var manager: CountManager
    
    @AppStorage("username") private var username: String = ""
    @AppStorage("giftProgressCounter") private var giftProgressCounter: Int = 0
    @AppStorage("sessionCounter") private var sessionCounter: Int = 0
    
    @State private var showNameInputAlert = false
    @State private var inputName = ""
    
    @AppStorage("dailyGoalValue") private var dailyGoalValue: Int = 100
    var dailyGoal: Double { Double(dailyGoalValue) }
    
    @State private var showRewardAlert = false
    let daysOfWeek = ["السبت", "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة"]
    
    var body: some View {
        VStack(spacing: 15) {
            // 1️⃣ الجزء العلوي: الترحيب والهدية المصغرة
            HStack {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(username.isEmpty ? "مرحباً بك" : "مرحباً، \(username) 👋")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("طاب يومك بذكر الله")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("🎁")
                        .font(.system(size: 20))
                    
                    ProgressView(value: min(Double(giftProgressCounter), dailyGoal), total: dailyGoal)
                        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        .frame(width: 80)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .cornerRadius(3)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer()
            
            // 2️⃣ شاشة العداد الكبيرة
            VStack(spacing: 5) {
                Text("\(sessionCounter)")
                    .font(.system(size: 85, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .id(sessionCounter)
                
                Text("إجمالي التسبيحات")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 3️⃣ أزرار التحكم النظيفة
            HStack(spacing: 40) {
                Button(action: {
                    sessionCounter = 0
                    giftProgressCounter = 0
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.red)
                        .padding(12)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Button(action: {
                    sessionCounter += 1
                    giftProgressCounter += 1
                    manager.logCount()
                    
                    if Double(giftProgressCounter) >= dailyGoal {
                        showRewardAlert = true
                    }
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }) {
                    Text("سبّح")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 125, height: 125)
                        .background(
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.bottom, 20)
            
            // 4️⃣ الجزء السفلي: إحصائيات تقدم أيام الأسبوع
            VStack(alignment: .trailing, spacing: 8) {
                Text("📅 تقدم أيام الأسبوع")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                ForEach(daysOfWeek, id: \.self) { day in
                    let dayCount = manager.getCountFor(dayName: day)
                    
                    HStack {
                        ProgressView(value: min(Double(dayCount), dailyGoal), total: dailyGoal)
                            .progressViewStyle(LinearProgressViewStyle(tint: isCurrentDay(day) ? .blue : .gray.opacity(0.4)))
                            .frame(width: 90)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                            .cornerRadius(2)
                        
                        Text("\(dayCount)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(width: 35, alignment: .leading)
                        
                        Spacer()
                        
                        Text(day)
                            .font(.caption)
                            .fontWeight(isCurrentDay(day) ? .bold : .regular)
                            .foregroundColor(isCurrentDay(day) ? .blue : .primary)
                            .frame(width: 60, alignment: .trailing)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: -4)
            .padding(.horizontal)
            
        } // نهاية الـ VStack
        .onAppear {
            if username.isEmpty {
                showNameInputAlert = true
            }
        }
        .alert("مرحباً بك في المسبحة الذكية", isPresented: $showNameInputAlert) {
            TextField("اكتب اسمك هنا...", text: $inputName)
                .environment(\.layoutDirection, .rightToLeft)
            Button("حفظ", action: {
                if !inputName.trimmingCharacters(in: .whitespaces).isEmpty {
                    username = inputName
                } else {
                    username = "ذاكر"
                }
            })
        } message: {
            Text("يرجى إدخال اسمك لتخصيص تجربتك النورانية.")
        }
        .alert(isPresented: $showRewardAlert) {
            Alert(
                title: Text("🎉 هنيئاً لك!"),
                message: Text("لقد أتممت هدفك اليومي بنجاح. استمر في هذا العطاء! ✨"),
                dismissButton: .default(Text("الحمد لله"), action: {
                    giftProgressCounter = 0
                })
            )
        }
    } // نهاية الـ body
    
    func isCurrentDay(_ dayName: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateFormat = "EEEE"
        let currentDayFromSystem = formatter.string(from: Date())
        return currentDayFromSystem.replacingOccurrences(of: "إ", with: "ا") == dayName.replacingOccurrences(of: "إ", with: "ا")
    }
}
