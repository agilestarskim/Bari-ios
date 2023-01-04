//
//  Message.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        VStack {
            List(0..<10, id: \.self) { index in
                HStack{
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading, spacing: 8){
                        Text("채팅방 이름")
                            .font(.title)
                        Text("마지막 채팅")
                            .font(.callout)
                    }
                    Spacer()
                    Text("오후 \(index+1):\(index+20)")
                        .font(.caption2)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
