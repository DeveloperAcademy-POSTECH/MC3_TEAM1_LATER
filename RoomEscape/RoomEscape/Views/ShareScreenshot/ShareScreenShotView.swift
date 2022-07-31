//
//  ShareScreenShotView.swift
//  RoomEscape
//
//  Created by Wonhyuk Choi on 2022/07/28.
//

import SwiftUI

struct ShareScreenShotView: View {
    let forWhom: String
    let rooms: [RoomModel]
    let images: [UIImage?]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(forWhom)를 위해\n준비했어요")
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 23)
                    .padding(.top, 21)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 32))
                Spacer()
            }
            ForEach(Array(rooms.enumerated()), id: \.offset) { idx, room in
                VStack (alignment: .leading) {
                    ThemePoster(
                        image: images[idx],
                        genre: room.genre,
                        title: room.title,
                        storeName: room.storeName
                    )
                    DescriptionContainer(description: room.description)
                        .padding(.top, 24)
                }
            }
            .padding(.horizontal, 27)
            .padding(.vertical, 40)
        }
        .background(Color("Background"))
    }
}

struct ShareScreenShotView_Previews: PreviewProvider {
    static var previews: some View {
        ShareScreenShotView(
            forWhom: "룸메즈",
            rooms: [
                RoomModel(
                    id: 1,
                    location: "대구광역시",
                    storeName: "룸즈에이 대구 동성로점",
                    address: "대구광역시 중구 동성로6길 16",
                    phoneNumber: "0507-1389-3838",
                    homepage: "http://roomsa.co.kr/new_main.asp?R_JIJEM=S10",
                    image: "http://roomsa.co.kr/upload_file/thema/maintheme(15).jpg",
                    title: "취중진담",
                    genre: "감성/스토리",
                    difficulty: 4,
                    activity: 3,
                    horror: 1,
                    description: "이곳은 누군가의 과거로 가볼 수 있는 술집입니다. 칵테일 한 잔에 과거의 이야기를 알 수 있는 술집이라... 이곳을 찾은 손님들의 취중진담을 들어볼까요?",
                    recommendation: "몽글몽글한 감성 스토리를 좋아하시는 분"
                ),
                RoomModel(
                    id: 2,
                    location: "대구광역시",
                    storeName: "룸즈에이 대구 동성로점",
                    address: "대구광역시 중구 동성로6길 16",
                    phoneNumber: "0507-1389-3838",
                    homepage: "http://roomsa.co.kr/new_main.asp?R_JIJEM=S10",
                    image: "http://roomsa.co.kr/upload_file/thema/maintheme(14).jpg",
                    title: "노블리스트",
                    genre: "스토리/스릴러",
                    difficulty: 4,
                    activity: 4,
                    horror: 3,
                    description: "만년 작가 지망생 ‘송설’은 어느 날 BOOKS A 출판사에서 진행한 <연구소> 출간기념 이벤트에 당첨되어 평소 동경하던 유명한 소설 작가인 ‘노블’과의 식사권을 얻게 된다. 설레는 마음으로 그녀는 그를 만나러 가는데...",
                    recommendation: "끝이 없이 이어지는 문제를 푸는 걸 즐기시는 분"
                )
            ],
            images: [
                UIImage(systemName: "house"),
                UIImage(systemName: "house.fill")
            ]
        )
    }
}
