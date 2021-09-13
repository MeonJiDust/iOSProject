import UIKit

var greeting = "Optional"


//옵셔널 바인딩에 대해 공부를 해보아요

//스위프트의 ?와 !는 옵셔널 기호!! 옵셔널은 선택적인- 인데 스위프트에서 이 선택적인 경우가 필요한 이유는 변수 안에 값이 있을 수도 있어고 없을 수도 있는 경우가 있어서!!

var test: Int
//test = nil //<-이건 오류!! test 안에는 int형 즉, 정수 타입만 올 수 있는데 지정한 값은 nil값이기 때문에!
//다시말해 Int타입에 Int타입이 아닌 것을 넣으니 저 test라는 메모리 공간이 초기화될 수 없다는 것이다.

//근데 코딩을 하다보면 변수 안에 값이 들어갈 수도 있고 안 들어가는 경우가 발생.
//따라서 변수 안에 값이 확실히 있다는 것을 보장할 수 없다면 옵셔널을 써야함!!

var test1: Int?
test1 = nil // <-이렇게 쓰면 오류가 나지 않음!!
//옵셔널 변수는 초기화하지 않는다면 nil로 자동 초기화

//평소에 그냥 var test: Int = 30 으로 그냥 상자안에 들어있지 않은 변수 상태라 생각하자.
//옵셔널 변수는 일단 상자에 한 번 싸여있다. 따라서 그 상자 안에 값이 있는지 없는지 알 수가 없는 상태이다.
//이제 옵셔널 기호 ?랑 !에 대해 알아보아요!

//?
//옵셔널로 변수가 선언된다면 우선 xcode는 상자 하나를 만들 것이다. 만약 거기에 ?가 붙어있으면 xcode는 상자에 '노크'를 하게 돼!!
//만약 상자에 값이 있다면 변수는 그 값을 반환해줄거야. 근데 열었는데 아무것도 없어! 그럼 nil값을 반환해. 그리고 안에 nil값이 있어도 메모리는 차지해!

var someValue: Int? = 30
var Value = someValue
//여기서 Value라는 변수는 옵셔널 타입의 변수이고 Int형 타입을 가질 수도 있는 변수야! 왜냐하면 someValue가 정수형일 수도 아닐 수도 있기 때문에! 따라서 일단 Value는 옵셔널 변수!
//근데 이 때 var Value: Int = someValue라고 해버리면 일단 someValue는 정수형일 수도 아닐 수도 있는데 Value가 Int라고 선언해버리면 만약 someValue가 nil이면 오류이기 때문에 미리 그건 안 돼! 라고 오류를 내주는 것이다.
//따라서 여기서 알 수 있는 것은 Int와 Int?는 다른 타입이다!!

//!
var someValue2: Int? = 30
var Value2: Int = someValue!
//라고 하면 오류가 안 나는데 그 이유는 someValue라는 상자 안에서 강제로 값을 꺼내고 Value에 넣으니까 오류가 안 나는 것이다.
//하지만 someValue안에 있는 값이 정수형이 아니라 nil이라면..?! 그럼 런타임에러가 발생하기 때문에 !로 강제 언랩핑을 하려면 항상 꼭 옵셔널 값이 nil이 아니라는 것을 확실히 해야함.


//옵셔널 바인딩!

//옵셔널 바인딩은 주로 if let이나 it var구문과 같이 쓰임.
//옵셔널 바인딩 == 먼저 체크해준다!
//해당 변수 안의 값이 nil인지 값이 있는지 경우에 따라 결과를 달리하고 싶을 때 옵셔널 바인딩을 사용!

//ex)
func printName(_name: String){
    print(_name)
}

var myName: String? = nil

if let name = myName{
    printName(_name: name)
}
//여기서 If let구문은 myName이라는 상자에 노크해보고 값이 있으면 name에 그 값을 넣어주고 조건문을 실행해-!!라는게 된다.
//하지만 여기서는 myName에 nil이 있어서 조건문을 실행하지 않는다. 값이 있을 때만 값이 바인딩된다!!


var height: Int? = 170

if let value = height{
    if value >= 160{
        print("wow")
    }
}
var age: Int? = 33

if let value2 = height, value2 >= 33{
    print("wow")
}


//옵셔널 체이닝이란,,,

//ex)
class Person{
    
    var residence: Residence?
    //residence 변수가 Residence클래스를 상속받음
    //옵셔널 기호 ?를 같이 줌
    //따라서 아래에 Person 타입의 인스턴스가 만들어지면 residence변수의 초기 값은 nil이 됨!!
}
class Residence{
    
    var numberOfRooms = 1
}

let zedd = Person()
//여기서 Person타입의 인스턴스가 zedd로 만들어짐
//zedd의 프로퍼티로 residence가 있음!(Person클래스의 멤버 변수이기 때문에!)
//하지만 residence변수는 Residence클래스를 옵셔널 타입으로 상속받고있기 때문에 residence에는 값이 있을 수도 없을 수도 있음
//따라서 따로 초기화시키지 않은 zedd의 residence값은 nil이다.

//zedd.residence = Residence()
//이 코드를 쓰면 초기값으로 nildl 들어있던 zedd.residence의 값은 더이상 nil이 아니게 된다.
if let roomCount = zedd.residence?.numberOfRooms{
    //이 부분이 옵셔널 체이닝!!
    //프로퍼티를 통해 게속 체인처럼 이어져있음
    //우선 residence뒤에 ?이 붙어있는 이유는 zedd.residence의 값이 nil일 수도 있고 아닐 수도 있기 때문이다.
    //다시 돌아와서..- zedd의 residence가 nil이 아니라면 numberOfRooms도 확인!
    //여기서 zedd는 nil이기 때문에 바로 else 문으로 간다.
    //만약 if문을 실행하고 싶다면
    print("zedd's residence has \(roomCount) room")
} else{
    print("Unable to retrieve the number of rooms.")
}


//연산자. 초큼 복잡함,,,
//스위프트에서 연산자란 특정한 문자로 표현한 함수라 할 수 있음. 따라서 특정 연산자의 역할을 프로그래머의 의도대로 변경할 수도 있음.
//연산자에 의해 연산 되는 값의 수에 따라 단항, 이항, 삼항, 등으로 구분하기도 하며, 연산자의 위치에 다라 전위, 중위, 후위 등으로 구분하기도 함.

//단항연산자: 피연산자가 한 개인 연산자 !A
//이항연산자: 피연산자가 두 개 A + B
//그래!! 너가 생각하는 그거 맞아!!! 삼항연산자는 A ? B : C 막 이런거!!!!

//나누기 연산자 /
//나머지 연산자 %
//


