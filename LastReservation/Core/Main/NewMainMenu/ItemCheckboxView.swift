import SwiftUI
import FirebaseFirestore
import Firebase

struct ItemCheckboxView: View {
    @State private var selectedItems: [String] = []
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedItemCount = 0
    let items = ["Computer 1", "Computer 2", "Computer 3", "Computer 4", "Computer 5", "Computer 6", "Computer 7", "Computer 8", "Computer 9", "Computer 10"]
    
    func itemSelected(itemName: String) {
          if selectedItemCount < 3 {
              selectedItems.append(itemName)
              selectedItemCount += 1
          }
      }
    
    
    func addItemsToReservation(email: String, items: [String]) {
        let db = Firestore.firestore()
        
        // Rezervasyonlar koleksiyonundaki belgelere sorgu yaparak, eşleşen belgeyi buluyoruz
        db.collection("Reservations").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching reservations: \(error)")
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                print("No matching reservations found")
                return
            }
            
            // Eşleşen belgeyi bulduktan sonra, belgeye itemleri ekleyebiliriz
            let reservationRef = db.collection("Reservations").document(document.documentID)
            reservationRef.updateData(["selectedItems": FieldValue.arrayUnion(items)]) { error in
                if let error = error {
                    print("Error updating reservation: \(error)")
                } else {
                    print("Items added to reservation successfully")
                }
            }
        }
    }




    var body: some View {
        VStack {
            Text("İtemler")
                .font(.title)
                .padding()
            Divider()
            ScrollView {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                            .font(.headline)
                        Spacer()
                        Image(systemName: selectedItems.contains(item) ? "checkmark.square.fill" : "square")
                            .foregroundColor(selectedItems.contains(item) ? .green : .black)
                            .onTapGesture {
                                if let index = selectedItems.firstIndex(of: item) {
                                    selectedItems.remove(at: index)
                                } else {
                                    itemSelected(itemName: item)
                                }
                            }
                    }
                    Divider()
                }
            }
            HStack {
                Button(action: {
                    if let user = authViewModel.currentUser {
                        addItemsToReservation(email: user.email, items: selectedItems)
                    }

                }, label: {
                    Text("Onayla")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                })
                Spacer()
                Button(action: {
                    selectedItems = []
                        selectedItemCount = 0
                }, label: {
                    Text("İptal")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                })
            }
            .padding()
        }
        .padding()
    }
}








