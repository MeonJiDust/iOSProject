
## OverView
일정을 등록할 수 있으며, 카테고리별로 저장, 삭제 및 알림 등이 가능한 일정관리 ENIAC Project 앱.
<br>

## About The Project


### Main Component Used
- MVVM Pattern
- TabBar, TableView, FSCalendarView(Library) ...
- Codable
<br>

### 배운점
- 하나의 모델을 여러가지 형태의 Object 로 만들어 필요한 곳에 쓰일 수 있도록 변형.
- 원하는 일정별로 Notification 구성.
- Codable 을 이용해 Custom Object에 대한 저장, 접근, 삭제 구현.
- 적절한 extenstion 을 사용하여 코드를 가독성 있도록 구성.
<br>

### 셀피 (셀프 피드백 ㅋㅋㅋㅋㅋㅋ하하하하하하하하하)
- 하나의 Model 을 각기 다른 형식으로 TableView 에 road 시켜야 했기 때문에, Model 을 여러 Object 로 만드는 과정에서 연산 복잡도가 늘어남.
- StoryBoard 와 Code 의 혼용으로 기능을 추가할 때 오히려 더 복잡해짐.
- Access Control 을 더욱 세밀하게 하지 못함.
