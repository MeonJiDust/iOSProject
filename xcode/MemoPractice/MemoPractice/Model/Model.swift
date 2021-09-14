//
//  Model.swift
//  MemoPractice
//
//  Created by 이시현 on 2021/09/14.
//

import Foundation

class Memo{
    var content: String
    var insertDate: Date
    
    init(content: String){ //속성들을 초기화하는 생성자
        self.content = content
        insertDate = Date() //insertDate에는 현재 시간을 그대로 받으면 되기 때문에 별도의 파라미터가 필요없다.
    }
    
    static var dummyMemoList = [
        Memo(content: "Lorem Ipsum"),
        Memo(content: "Subscribe + 🔅 = 🐶")
    ]
}
