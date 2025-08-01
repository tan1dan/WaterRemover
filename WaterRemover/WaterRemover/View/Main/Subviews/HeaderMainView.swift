

import SwiftUI

struct HeaderMainView: View {
    
    @Binding var isSettings: Bool
    @Binding var isPaywall: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            HapticButton {
                //TODO Pywall
                isPaywall = true
            } label: {
                Text("PRO")
                    .frame(width: 48, height: 25)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 30))
                    .foregroundStyle(Color.text)
                    .font(.gilroy(size: 14, weight: .bold))
            }

            
            Spacer()
            
            Text("Clear Wave")
                .foregroundStyle(.white)
                .font(.gilroy(size: 24, weight: .bold))
            
            Spacer()
            HapticButton {
                //TODO Settings
                isSettings = true
            } label: {
                Image(.settings)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}
