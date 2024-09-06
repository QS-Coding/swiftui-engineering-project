import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @State private var userInput: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showPhotoPicker = false
    @State private var isUploadingImage = false
    @Environment(\.presentationMode) var presentationMode  // Handle modal dismissal

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                // Cancel Button to dismiss CreatePostView
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()  // Dismiss the view
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .padding(.leading, 20)
                Spacer()
            }
            .padding(.top, 20)

            Spacer()

            Text("Make a Post")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            ZStack {
                // White background box
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(minWidth: 100, maxWidth: 300, minHeight: 120, maxHeight: 100)
                    .shadow(radius: 5)  // Optional: Adds a shadow for better visibility

                // Post Text Field
                TextField(
                    "Write what you would like to post...",
                    text: $userInput,
                    axis: .vertical
                )
                .padding(.bottom, 120)  //this is a hack to raise the text to the top
                .padding(.horizontal, 16)
                .frame(minWidth: 100, maxWidth: 300, minHeight: 100, maxHeight: 200)
                   .background(Color(.white))
                   .cornerRadius(30)
                   .padding(.horizontal, 20)
            }
    

            // Show selected image preview
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
            }

            // Action Buttons - Centered
            HStack(alignment: .center, spacing: 20) {
                Button("Add Image") {
                    showPhotoPicker = true  // Show the photo picker
                }
                .frame(width: 120, height: 44)
                .background(Color.blue)
                .cornerRadius(40)
                .foregroundColor(.white)

                Button("Create Post") {
                    Task {
                        do {
                            var imageUrl: String? = nil
                            if let selectedImage = selectedImage {
                                isUploadingImage = true
                                // Upload the image to Cloudinary and get the image URL
                                imageUrl = try await PostService.uploadImageToCloudinary(image: selectedImage)
                            }

                            // Create the post with or without an image URL
                            _ = try await PostService.createPost(message: userInput, image: selectedImage)
                            
                            // Show success alert
                            alertTitle = "Post Created"
                            alertMessage = "Your post has been created successfully."
                            showAlert = true
                            
                        } catch {
                            // Show error alert
                            alertTitle = "Error"
                            alertMessage = "Failed to create the post. Please try again."
                            showAlert = true
                        }
                    }
                }
                .frame(width: 120, height: 44)
                .background(Color.blue)
                .cornerRadius(40)
                .foregroundColor(.white)
                .disabled(isUploadingImage)  // Disable if image is uploading
            }
            .padding(.top, 30)

            Spacer()

            // Alert for showing success or error message
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"), action: {
                        if alertTitle == "Post Created" {
                            // Dismiss the CreatePostView modal and return to MainView
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                )
            }
        }
        .background(Color(red: 0, green: 0.96, blue: 1).ignoresSafeArea())  // Cover entire screen with background color
        .navigationBarHidden(true)  // Hide default navigation bar
        .sheet(isPresented: $showPhotoPicker) {
            // Use SwiftUI's photo picker
            PhotoPicker(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    CreatePostView()
}
