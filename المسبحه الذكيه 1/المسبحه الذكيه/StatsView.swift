import SwiftUI

struct StatsView: View {
    // استقبال مدير البيانات المشترك
    @ObservedObject var manager: CountManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // كرت الإحصائية الإجمالية
                    VStack(spacing: 10) {
                        Text("📊 إجمالي كل الأيام")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(manager.getAllTimeTotal())")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.purple)
                        
                        Text("تسبيحة منذ بداية رحلتك")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.08))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // كرت إحصائية الشهر الحالي
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            Text("🌙 حصاد الشهر الحالي")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(manager.getCurrentMonthTotal())")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text("تسبيحة هذا الشهر")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            let monthGoal: Double = 3000.0
                            let percentage = min(Double(manager.getCurrentMonthTotal()) / monthGoal, 1.0)
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                                    .frame(width: 70, height: 70)
                                
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(percentage))
                                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 70, height: 70)
                                    .rotationEffect(Angle(degrees: -90))
                                
                                Text("\(Int(percentage * 100))%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // السجل المفصل للأيام
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("📜 السجل المفصل للأيام الأخيرة")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if manager.dailyLogs.isEmpty {
                            Text("لم يتم تسجيل أي تسبيحات بعد. ابدأ بالتسبيح لتظهر بياناتك هنا!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(manager.dailyLogs.reversed().prefix(7)) { log in
                                HStack {
                                    Text("\(log.count) تسبيحة")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(log.dayName)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                        Text(log.dateString)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding(.top)
            }
            .navigationTitle("الإحصائيات والتقارير")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
