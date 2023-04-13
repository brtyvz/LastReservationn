import SwiftUI
import Firebase

struct NewMainMenu: View {
    @StateObject var viewModel = denemeViewModel()
    @State private var days = [Days]()
    @State private var selectedDay: Days?
    @State private var currentDate = Date()
    @State private var selectedSession: String?
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) { // Günler arasındaki boşluğu azalt
                    ForEach(days) { day in
                        Button(action: {
                            selectedDay = day
                            selectedSession = nil // Seçili günlük değişince session seçimini sıfırla
                        }) {
                            VStack {
                                Text(day.date.dateValue(), style: .date)
                                    .foregroundColor(selectedDay == day ? .white : .white)
                            }
                            .padding()
                            .background(
                                Capsule()
                                    .fill(selectedDay == day ? Color.black.opacity(0.6) : Color.black.opacity(0.9))
                                    .overlay(
                                        Text(day.date.dateValue(), style: .date)
                                            .foregroundColor(.white)
                                            .opacity(selectedDay == day ? 1.0 : 0.0)
                                    )
                            )
                            .padding(.vertical)
                        }
                    }.padding(5)
                }
            }
            if showConfirmation {
                ConfirmationView(selectedDay:selectedDay,showConfirmation: $showConfirmation, selectedSession: selectedSession, capacity: selectedDay?.sessions[selectedSession ?? ""]?.capacity)
            }
            
            Divider()
            
            ScrollView {
                VStack {
                    if let day = selectedDay {
                        ForEach(day.sessions.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Button(action: {
                                selectedSession = key // Session butonuna tıklandığında seçili session'ı güncelle
                                self.showConfirmation = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading) { // Session ve capacity yazılarını alt alta ekledik
                                        Text("Session")
                                            .font(.headline)
                                            .foregroundColor(.black) // Session yazısının rengini ayarla
                                        Text(key)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    Text("Capacity")
                                        .font(.headline)
                                        .foregroundColor(.black) // Capacity yazısının rengini ayarla
                                    Text("\(value.capacity)")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, selectedSession == key ? 26 : 22) // Seçili session için ekstra padding uygula
                                .background(
                                    Capsule()
                                        .fill(selectedSession == key ? Color.purple.opacity(0.5) : Color.purple.opacity(0.2)) // Seçili session için arka plan rengini güncelle
                                )
                            }
                            .buttonStyle(PlainButtonStyle()) // Session butonlarına basıldığında highlight efekti kaldır
                            .frame(maxWidth: .infinity) // Butonların genişliğini maksimuma çıkararak daha uzun yap
                            .padding(.horizontal, 16) // Butonların yatay padding'ini arttırarak daha uzun yap
                            .padding(.bottom, 10) // Butonların alt tarafına padding ekle
                        }
                    } else {
                        Text("Lütfen bir tarih seçin")
                            .padding()
                    }
               

                }
            }
        }
        .onAppear {
            fetchCurrentWeekDays()
        }
    }
    
    func fetchCurrentWeekDays() {
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        viewModel.fetchDays(startOfWeek: startOfWeek, endOfWeek: endOfWeek) { result in
            switch result {
            case .success(let days):
                self.days = days
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
