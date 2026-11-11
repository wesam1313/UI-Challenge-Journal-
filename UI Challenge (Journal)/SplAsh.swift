import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("Journal")
                
            Text("Journali")
                .font(.largeTitle)
                .bold()
                .fontWeight(.black)
                .foregroundStyle(Color("Text Primary"))
            
            Text("Your thoughts, your story")
                .font(.subheadline)
                .foregroundStyle(Color("Text Secondary"))
        } .preferredColorScheme(.dark)
    }
}
    
#Preview {
    SplashView()
}

