//
//  DescriptionContainer.swift
//  RoomEscape
//
//  Created by Wonhyuk Choi on 2022/07/29.
//

import SwiftUI

struct DescriptionContainer: View {
    let description: String
    
    var body: some View {
        Text(description)
            .foregroundColor(Color("text2"))
            .multilineTextAlignment(.leading)
            .lineSpacing(10)
            .padding(.vertical, 21)
            .padding(.horizontal, 16)
            .frame(width: 400)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color("Background2"))
            )
    }
}

struct DescriptionContainer_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionContainer(
            description: "멸종 위기의 지구별. 드디어 우리는 인간이 살 수 있는 외계행성을 발견했다.\n새로운 세계에 대한 갈망으로 폭주한 지원경쟁을 뚫고, 혹독한 행성 환경을 탐사하기 위한 최종 선발대 트레이닝 과정에 입소한 당신.\n당신은 인류의 위대한 영웅이 될 자격이 있는가?"
        )
            .previewLayout(.sizeThatFits)
    }
}
