//
//  Friends.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI

struct FriendsView: View {
    enum Menu: String, CaseIterable{
        case list = "친구 목록"
        case add = "친구 추가"
    }
    //만약 친구 수가 0이라면 친구 추천이 디폴트
    @State private var selectedMenu: Menu = .list
    @State private var inputPhoneNumber = ""
    var body: some View {
        VStack {
            Picker("select menu", selection: $selectedMenu) {
                ForEach(Menu.allCases, id: \.self) {
                    Text($0.rawValue)
                        .fontWeight(.semibold)
                }
            }
            .pickerStyle(.segmented)
            .padding(.top, 30)
            .padding(.horizontal)
            Spacer()
            if selectedMenu == .list {
                List(0..<30) { index in
                    HStack {
                        Image("profile")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 44, height: 44)
                        Text("홍길동")
                            .font(.title3)
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(index < 5 ? .yellow : .clear)
                    }
                }
                .scrollIndicators(.hidden)
            }
            else {
                Form {
                    Section("전화번호로 추가하기") {
                        HStack{
                            TextField("010-1234-1234", text: $inputPhoneNumber)
                            Spacer()
                            Button("추가") {
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.trailing, 0)
                        }
                    }
                    
                    Section {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 20) {
                                ForEach(0..<10, id:\.self) { _ in
                                    VStack {
                                        Image("profile")
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 55, height: 55)
                                        Text("홍길동")
                                            .font(.title)
                                        Button("추가") {
                                            
                                        }
                                        .buttonStyle(.borderedProminent)
                                    }
                                    .padding()
                                    .padding(.horizontal, 20)
                                    .background(.ultraThickMaterial)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    } header: {
                        HStack{
                            Text("알 수도 있는 친구")
                            Spacer()
                            Button("전체보기"){}
                                .foregroundColor(.secondary)
                        }
                      
                    }
                    
                }
            }
            
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct Friends_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
