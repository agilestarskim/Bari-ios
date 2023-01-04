//
//  Profile.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var mapVm: MapViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                Text("김민성")
                    .font(.largeTitle)
                Spacer()
                Button("편집") {
                    
                }
            }
            Divider()
            Text("현재 위치")
                .font(.caption)
                .padding(.bottom, 10)
            Text(mapVm.placeFullName)
                .font(.body)
                
            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(mapVm: MapViewModel())
    }
}
