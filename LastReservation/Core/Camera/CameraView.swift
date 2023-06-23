//
//  CameraView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 30.04.2023.
//

import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage

struct CameraView: View {
    @StateObject var camera = CameraModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        ZStack {
            
         CameraPreview(camera: camera)
                .ignoresSafeArea(.all,edges: .all)
            
            VStack {
                if camera.isTaken {
                    HStack{
                        Spacer()
                        Button(action: {camera.reTake()}, label: {
                       Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                    .padding(.trailing,10)
                }
                }
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        
                        Button(action:
                                {
                            if let user = authViewModel.currentUser {
                                
                                if !camera.isSaved{camera.savePic(email: user.email)}
                                
                            }
                           },
                               label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        Spacer()
                    }
                    else {
                        Button(action: camera.takePic, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white,lineWidth:2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear {
            camera.Check()
        }
    }
}


class CameraModel:NSObject,ObservableObject,AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
  



    
    func Check(){
        // camera permission check
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .authorized:
            setUp()
            return
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    func setUp(){
        do{
            
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInDualCamera,for: .video,position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
            
        }
        
        catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)

          
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
            DispatchQueue.main.async { Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in self.session.stopRunning() } }
        }
    }
    
    func reTake(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()}
                self.isSaved = false
            }
        }
    }
    
    
    

    func saveImageToFirestore(image: UIImage, email: String) {
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        let imageName = UUID().uuidString + ".jpeg"
        let imagesRef = storageRef.child("\(imageName)")
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let uploadTask = imagesRef.putData(imageData, metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    print("Error uploading image: \(error)")
                    return
                }
                let size = metadata.size
                print("Image uploaded: \(size) bytes")
                
                // Firestore'da kullanıcının rezervasyonunu kontrol ediyoruz
                db.collection("Reservations").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("Error getting reservation documents: \(error)")
                        return
                    }
                    
                    // Eğer kullanıcının bir rezervasyonu varsa, fotoğrafı bu rezervasyona ekliyoruz
                    if let reservationDoc = documents.first {
                        let reservationId = reservationDoc.documentID
                        let dataToSave: [String: Any] = ["imageUrl": metadata.path ?? ""]
                        db.collection("Reservations").document(reservationId).updateData(dataToSave) { error in
                            if let error = error {
                                print("Error saving image URL to reservation document: \(error)")
                            } else {
                                print("Image URL saved successfully to reservation document")
                            }
                        }
                    } else {
                        print("User doesn't have any reservations")
                    }
                }
            }
            // Yükleme işlemi tamamlanana kadar bekleniyor.
            uploadTask.observe(.success) { snapshot in
                print("Upload completed successfully")
            }
        }
    }




    
    
    func photoOutput(_ output:AVCapturePhotoOutput, didFinishProcessingPhoto photo:AVCapturePhoto,error:Error?) {
        if error != nil {
            return
        }
        
        print("pic taken")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.picData = imageData
    }
    func savePic(email:String){
        let image = UIImage(data: self.picData)!
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
       
            saveImageToFirestore(image: image, email: email)
        
       
        self.isSaved = true
        print("saved succesfully")
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context)-> UIView {
    let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
    camera.preview.frame = view.frame
    // Your Own Properties.
        camera.preview.videoGravity = .resizeAspectFill
    view.layer.addSublayer(camera.preview)
    
    // starting session
     camera.session.startRunning()
    return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}







//
//func saveImageToFirestore(image: UIImage) {
//    let db = Firestore.firestore()
//    let storageRef = Storage.storage().reference()
//    let imageName = UUID().uuidString + ".jpg"
//    let imagesRef = storageRef.child("images/\(imageName)")
//
//    if let imageData = image.jpegData(compressionQuality: 0.5) {
//        let uploadTask = imagesRef.putData(imageData, metadata: nil) { metadata, error in
//            guard let metadata = metadata else {
//                print("Error uploading image: \(error)")
//                return
//            }
//            let size = metadata.size
//            print("Image uploaded: \(size) bytes")
//
//            // Firestore'a kaydedilecek olan image url'sini almak için
//            imagesRef.downloadURL { url, error in
//                guard let downloadURL = url else {
//                    print("Error getting download URL: \(error)")
//                    return
//                }
//
//                // Firestore'a image dökümanı oluşturuluyor
//                let dataToSave: [String: Any] = ["imageUrl": downloadURL.absoluteString]
//                db.collection("Images").addDocument(data: dataToSave) { error in
//                    if let error = error {
//                        print("Error saving image document: \(error)")
//                    } else {
//                        print("Image document saved successfully")
//                    }
//                }
//            }
//        }
//        // Yükleme işlemi tamamlanana kadar bekleniyor.
//        uploadTask.observe(.success) { snapshot in
//            print("Upload completed successfully")
//        }
//    }
//}
