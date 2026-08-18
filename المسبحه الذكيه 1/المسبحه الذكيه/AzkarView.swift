import SwiftUI

struct ZikrItem: Identifiable {
    let id = UUID()
    let text: String
    let reward: String
    var count: Int
    var initialCount: Int
}

struct ZikrCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let items: [ZikrItem]
}

struct AzkarView: View {
    let categories = [
        ZikrCategory(name: "أذكار الصباح", icon: "sun.max.fill", color: .orange, items: [
            ZikrItem(text: "أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده.", reward: "حفظ حمايته حتى يمسي", count: 1, initialCount: 1),
            ZikrItem(text: "قراءة آية الكرسي: الله لا إله إلا هو الحي القيوم.", reward: "لن يزال عليك من الله حافظ", count: 1, initialCount: 1),
            ZikrItem(text: "قل هو الله أحد، وقل أعوذ برب الفلق، وقل أعوذ برب الناس.", reward: "تكفيك من كل شيء", count: 3, initialCount: 3),
            ZikrItem(text: "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء.", reward: "لم يضره شيء في يومه", count: 3, initialCount: 3)
        ]),
        
        ZikrCategory(name: "أذكار المساء", icon: "moon.stars.fill", color: .purple, items: [
            ZikrItem(text: "أمسيننا وأمسي الملك لله، والحمد لله لا إله إلا الله.", reward: "حفظ حمايته حتى يصبح", count: 1, initialCount: 1),
            ZikrItem(text: "أعوذ بكلمات الله التامات من شر ما خلق.", reward: "لم تضره لدغة في ليلته", count: 3, initialCount: 3),
            ZikrItem(text: "اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك.", reward: "سيد الإستغفار: موجب للجنة", count: 1, initialCount: 1)
        ]),
        
        ZikrCategory(name: "أذكار بعد الصلاة", icon: "mosque.fill", color: .green, items: [
            ZikrItem(text: "أستغفر الله، أستغفر الله، أستغفر الله. اللهم أنت السلام.", reward: "تقال فور التسليم من الصلاة", count: 1, initialCount: 1),
            ZikrItem(text: "سبحان الله (33)، الحمد لله (33)، الله أكبر (33)", reward: "تغفر الخطايا وإن كانت كزبد البحر", count: 1, initialCount: 1)
        ]),
        
        ZikrCategory(name: "أدعية مأثورة", icon: "sparkles", color: .blue, items: [
            ZikrItem(text: "لا إله إلا أنت سبحانك إني كنت من الظالمين.", reward: "استجابة الدعاء وتفريج الكرب", count: 3, initialCount: 3),
            ZikrItem(text: "لا حول ولا قوة إلا بالله العلي العظيم.", reward: "كنز من كنوز الجنة", count: 10, initialCount: 10)
        ])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Text("﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                    
                    ForEach(categories) { category in
                        NavigationLink(destination: ZikrDetailsView(category: category)) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text(category.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ZStack {
                                    Circle()
                                        .fill(category.color.opacity(0.15))
                                        .frame(width: 45, height: 45)
                                    
                                    Image(systemName: category.icon)
                                        .font(.title3)
                                        .foregroundColor(category.color)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 3)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("الأذكار والأدعية")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ZikrDetailsView: View {
    let category: ZikrCategory
    @State private var items: [ZikrItem] = []
    
    init(category: ZikrCategory) {
        self.category = category
        _items = State(initialValue: category.items)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(0..<items.count, id: \.self) { index in
                    VStack(alignment: .trailing, spacing: 10) {
                        
                        Text(items[index].text)
                            .font(.system(size: 19, weight: .medium))
                            .multilineTextAlignment(.trailing)
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text(items[index].reward)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                        
                        HStack {
                            Button(action: {
                                items[index].count = items[index].initialCount
                            }) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if items[index].count > 0 {
                                    items[index].count -= 1
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                }
                            }) {
                                Text(items[index].count == 0 ? "✓ تم" : "\(items[index].count)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 40)
                                    .background(items[index].count == 0 ? Color.green : category.color)
                                    .cornerRadius(20)
                            }
                            .disabled(items[index].count == 0)
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .opacity(items[index].count == 0 ? 0.5 : 1.0)
                }
            }
            .padding(.top)
        }
        .navigationTitle(category.name)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
