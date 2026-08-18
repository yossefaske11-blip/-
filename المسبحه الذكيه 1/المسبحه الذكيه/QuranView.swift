import SwiftUI

struct QuranView: View {
    // حفظ آخر سورة قرأها المستخدم للعودة إليها كعلامة حفظ (Bookmark)
    @AppStorage("lastReadSurah") private var lastReadSurah: String = "الفاتحة"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    
                    // لافتة علوية توضح آخر سورة تم قراءتها
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("متابعة القراءة 📖")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("آخر ما قرأت: سورة \(lastReadSurah)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.06))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    Text("📜 فهرس السور الكريمة")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                    
                    // قائمة عرض السور
                    ForEach(quranSurahsList) { surah in
                        NavigationLink(destination: SurahDetailsView(surah: surah)) {
                            HStack {
                                // عدد الآيات ونوع السورة في اليسار
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(surah.versesCount) آية")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(surah.type)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(surah.type == "مكية" ? Color.orange.opacity(0.15) : Color.green.opacity(0.15))
                                        .foregroundColor(surah.type == "مكية" ? .orange : .green)
                                        .cornerRadius(5)
                                }
                                
                                Spacer()
                                
                                // اسم السورة ورقمها في اليمين
                                Text("سورة \(surah.name)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 35, height: 35)
                                    Text("\(surah.id)")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("المصحف الشريف")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 3️⃣ واجهة قراءة آيات السورة بالتفصيل
struct SurahDetailsView: View {
    let surah: QuranSurah
    @AppStorage("lastReadSurah") private var lastReadSurah: String = "الفاتحة"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // شكل جمالي لرأس السورة
                VStack(spacing: 8) {
                    Text("سُورَةُ \(surah.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("﴿ \(surah.type) • آياتها \(surah.versesCount) ﴾")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // عرض نص السورة كامل متصل بأسلوب المصحف المريح للعين
                VStack(alignment: .trailing, spacing: 15) {
                    // دمج الآيات مع وضع أرقامها في نهاية كل آية
                    Text(buildSurahText())
                        .font(.custom("Traditional Arabic", size: 24)) // خط عريض ومريح ومناسب للقرآن
                        .font(.system(size: 23, weight: .medium)) // خط احتياطي إذا لم يتوفر الأول
                        .multilineTextAlignment(.center)
                        .lineSpacing(12)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle(surah.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .onAppear {
            // حفظ اسم السورة الحالية تلقائياً كآخر سورة قرأها المستخدم عند دخول الشاشة
            lastReadSurah = surah.name
        }
    }
    
    // دالة دمج الآيات مع إضافة رمز ورقم الآية بصرياً بشكل رائع
    func buildSurahText() -> String {
        var fullText = ""
        for (index, verse) in surah.verses.enumerated() {
            fullText += verse + " ﴿\(index + 1)﴾ "
        }
        return fullText
    }
}

#Preview {
    QuranView()
}
