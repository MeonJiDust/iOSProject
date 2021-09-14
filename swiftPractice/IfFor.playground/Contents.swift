import UIKit

var greeting = "Hello, playground"

//if구문은 조건의 값이 꼭 Bool타입!
let first: Int = 5
let second: Int = 7

if first > second{
    print("yes")
}else if (first < second){ //소괄호로 묶어도 되고 안 묶어도 됨
    print("yesno")
}else{
    print("no")
}

//switch구문
//case내에 break문이 없어도 case가 끝나면 구문 종료
//case내의 문장 연속 실행 원할 시 fallthrough키워드 사용
//조건문에 정수 타입 뿐만 아니라 다양한 값 들어갈 수 있음.
//하지만 case에 들어갈 비교 값은 입력 값과 데이터 타입이 같아야 함.
//비교 값이 명확한 값이 아닐 때는 default를 꼭 작성!

let integerValue: Int = 5

switch integerValue{
case 0:
    print("Value == zero")
case 1 ... 10:
    print("value == 11")
default:
     print("d")
}

//튜플 스위치 구문

typealias NameAge = (name: String, age: Int)

let tupleValue: NameAge = ("tlgus", 21)

switch tupleValue{
case ("tlgus", 21):
    print("wjdghkrgo")
default:
    print("snrn?")
    
}


