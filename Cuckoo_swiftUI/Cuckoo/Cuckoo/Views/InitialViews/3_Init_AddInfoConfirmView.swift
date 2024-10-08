//
//  3_Init_AddInfoConfirmView.swift
//  Cuckoo
//
//  Created by DKSU on 2023/11/26.
//

import SwiftUI
import Combine
import CoreData
import Foundation


struct Init_AddInfoConfirmView: View {
    @ObservedObject var userViewModel = UserProfileViewModel.shared
    
    @State private var buttonText = "등록 완료"
    @State private var headerTitle = "마지막 확인!"
    @State private var navigateToNextScreen = false
    @State private var isAtBottom = false
    @State private var scrollViewHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    
    @State var term: Int = 1
    @State var multiplier: Int = 1
    
    
    init() {
        self.term = userViewModel.reminderPeriod
        self.multiplier = userViewModel.multiplier
    }
    
    @EnvironmentObject var globalState: GlobalState

    @Namespace var bottomID
    
    var body: some View {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    HeaderView(title: headerTitle)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)

                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            VStack(alignment: .center, spacing: 30) {
                                AddNameView(
                                    username: $userViewModel.username
                                )
                                    .frame(maxWidth: .infinity)
                                
                                BarDivider()

                                AddTagFormView()
                                    .frame(maxWidth: .infinity)
                                
                                BarDivider()
                                BarDivider()
                                
                                AddAlarmTermView(
                                    term: $term, 
                                    multiplier: $multiplier
                                )
                                    .frame(maxWidth: .infinity)
                                
                                BarDivider()
                                BarDivider()
                            
                                AddAlarmPresetView()
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.top, 30)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 120)
                            .frame(maxWidth: .infinity)

                            
                            
                            Color.clear.frame(height:0).id(bottomID)
                        }
                    }
                }
                .overlay(
                    VStack{
                        Spacer()
                        ConfirmFixedButton(confirmMessage: buttonText, logic: {
                            withAnimation(Animation.easeInOut(duration: 0.3)) {
                                scrollViewProxy.scrollTo(bottomID, anchor: .top)
                                
                                if !navigateToNextScreen {
                                    navigateToNextScreen = true;
                                } else {
                                    withAnimation {
                                        globalState.isRegistered = true;
                                        userViewModel.createUser(username: userViewModel.username, profileImagePath: nil)
                                    }
                                }

                            }
                            
                        })
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }, alignment: .leading)
                
            }.navigationBarBackButtonHidden(true)
    }
}

// 스크롤 뷰의 위치를 추적하기 위한 Key 정의
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct Init_AddInfoConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        Init_AddInfoConfirmView()
    }
}
