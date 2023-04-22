import SwiftUI

struct ItemCheckboxView: View {
    @State private var selectedItems: [String] = []
    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    
    var body: some View {
        VStack {
            Text("Items")
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
                                    selectedItems.append(item)
                                }
                            }
                    }
                    Divider()
                }
            }
            HStack {
                Button(action: {
                    print("Confirm tapped")
                }, label: {
                    Text("Confirm")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                })
                Spacer()
                Button(action: {
                    print("Cancel tapped")
                }, label: {
                    Text("Cancel")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                })
            }
            .padding()
        }
    }
}








