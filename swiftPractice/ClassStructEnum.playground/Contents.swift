import UIKit

var greeting = "Hello, playground"


//class, struct, enum의 차이점

//struct와 enum은 값타입 즉, call by value타입이고 class는 참조타입이다.(call by reference)
//(call by reference는 주소에 접근. 원본 수정 가능, call by value는 값의 사본을 변경. 원본은 유지

//class: 단일 상속만 가능!
//메서드, 프로퍼티
//call by reference! (참조타입! 주소에 접근)

//struct: 상속 불가능!
//메서드, 프로퍼티
//call by value(값타입! 사본으로 복사함)
class Point{
    
    var x = 0.0
    var y = 0.0
}

let point = Point.init()
