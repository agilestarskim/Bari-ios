//
//  ModeView.swift
//  Bari
//
//  Created by 김민성 on 2022/12/23.
//

import SwiftUI

enum Mode: String, CaseIterable {
    case publicMode = "투명"
    case roughMode = "안개"
    case privateMode = "숨김"
}

struct User: Identifiable, Equatable, Comparable{
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.name < rhs.name
    }
    
    var id = UUID()
    var name: String
    var isBest: Bool
    
}

struct ModeView: View {
    @State private var tempToggle1 = false
    @State private var tempToggle2 = false
    @State private var friends: [User] = [
        User(name: "김민성1", isBest: false),
        User(name: "김민성2", isBest: false),
        User(name: "김민성3", isBest: false),
        User(name: "김민성4", isBest: true),
        User(name: "김민성5", isBest: false),
        User(name: "김민성6", isBest: false),
        User(name: "김민성7", isBest: true),
        User(name: "김민성8", isBest: false),
        User(name: "김민성9", isBest: true)
    ].sorted(by: < )
    @State private var mode1: Mode = .publicMode
    @State private var mode2: Mode = .publicMode

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(friends){ user in
                        if user.isBest {
                            HStack{
                                Text(user.name)
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        guard let index = friends.firstIndex(of: user) else { return }
                                        withAnimation{
                                            friends[index].isBest.toggle()
                                        }
                                    }
                            }
                        }
                    }
                } header: {
                    VStack {
                        Picker("모드", selection: $mode1) {
                            ForEach(Mode.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .fontWeight(.semibold)
                            }
                        }
                        .pickerStyle(.segmented)
                        switch mode1 {
                        case .publicMode:
                            Text("내 위치를 공유합니다.")
                        case .roughMode:
                            Text("내 위치를 대략적으로 공유합니다.")
                        case .privateMode:
                            Text("내 위치를 숨깁니다.")
                        }
                    }
                    
                }
                
                Section {
                    ForEach(friends){ user in
                        if !user.isBest {
                            HStack{
                                Text(user.name)
                                Spacer()
                                Image(systemName: "star")
                                    .onTapGesture {
                                        guard let index = friends.firstIndex(of: user) else { return }
                                        withAnimation {
                                            friends[index].isBest.toggle()
                                        }
                                        
                                    }
                            }
                            
                        }
                    }
                } header: {
                    VStack{
                        Picker("모드", selection: $mode2) {
                            ForEach(Mode.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .fontWeight(.semibold)
                            }
                        }
                        .pickerStyle(.segmented)
                        switch mode2 {
                        case .publicMode:
                            Text("내 위치를 공유합니다.")
                        case .roughMode:
                            Text("내 위치를 대략적으로 공유합니다.")
                        case .privateMode:
                            Text("내 위치를 숨깁니다.")
                        }
                    }
                    
                }
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitle("모드 설정")
    }
}

