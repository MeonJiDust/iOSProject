import UIKit

var greeting = "Hello, playground"

//세트: 세트 내의 값은 유일한 값. 순서가 중요하지 않는 경우 사용
var names: Set<String> = Set<String>()
//or var names: Set<String> = []

names.insert("hihello")
print(names)
var names01: Set<String> = ["hi", "hello", "hihello"]

//세트의 활용: 포함관계
let bird: Set<String> = ["qlenfrl", "ekfr", "rlfjrl"]
let vhdb: Set<String> = ["tkwk", "ghfoddl", "rha"]
let ani: Set<String> = bird.union(vhdb) //새와 포유류의 합집합
print(bird.isDisjoint(with: vhdb))
print(ani.isSuperset(of: bird))//...

//열거형: 배열이나 딕셔너리 같은 타입과는 다르게 프로그래머가 정의해준 항목 값 외에는 추가, 수정이 불가. 따라서 딱 정해진 값만 열거형 값에 속할 수 있음
// 제한된 선택지를 주고 싶을 때, 정해진 값 외에는 입력받고 싶지 않을 때, 예상된 입력 값이 한정되어 있을 때 사용함.

//열거형 선언: enum
enum School{
    case primary
    case middle
    case high
    case college
    case graduate
    case elementary, university
}

//열거형 변수 선언
var highestEdu: School = School.university
// == var highestEdu: School = .university

enum School02: String{ //원시값 데이터형 지정
    case middle = "중학교"
    case high = "고등학교"
    case college = "대학교"
}

var myEdu: School02 = .middle
print("\(myEdu.rawValue)입니다.") //원시값을 사용하고싶다면 .rawValue프로퍼티 사용

let high = School02(rawValue: "고등학교")
let primary = School02(rawValue: "초등학교")

//연관값
enum MainDish{
    case pasta(taste: String)
    case pizza(dough: String, topping: String)
    case chicken(withSauce: Bool)
    case rice //다른 항목이 연관 값을 갖는다해서 모든 값이 연관 값을 가질 필요는 없다.
}

var dinner: MainDish = MainDish.pasta(taste: "크림")
dinner = .pizza(dough: "치즈", topping: "불고기")
dinner = .chicken(withSauce: true)
dinner = .rice

//열거형 응용
enum PastaTaste{
    case cream, tomato
}
enum PizzaDough{
    case cheeseCrust, thin, original
}
enum PizzaTopping{
    case pepperoni, cheese, bacon
}
enum MainDish02{
    case pasta(taste: PastaTaste)
    case pizza(dough: PizzaDough, topping: PizzaTopping)
    case chicken(withSauce: Bool)
    case rice
}

var dinner02: MainDish02 = .pasta(taste: PastaTaste.tomato)
dinner02 = .pizza(dough: PizzaDough.cheeseCrust, topping: PizzaTopping.bacon)
dinner02 = .chicken(withSauce: false)
dinner02 = .rice

//순환 열거형: 열거형 항목의 연관 값이 열거형 자신의 값이고자 할 때 사용. 순환 열거형을 명시하고싶다면 indirect 키워드 사용
enum ArithmeticExpression{
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//순환 열거형 사용 예
let five: ArithmeticExpression = ArithmeticExpression.number(5)
let four: ArithmeticExpression = ArithmeticExpression.number(4)
let sum: ArithmeticExpression = ArithmeticExpression.addition(five, four)
let final: ArithmeticExpression = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int{
    switch expression{
    case .number(let value):
        return value
    case .addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}

let result: Int = evaluate(final)
print(result)
