<p align="center">
  <img src="https://user-images.githubusercontent.com/56511253/120443507-ab00e880-c3c1-11eb-834e-2bcaba81d28e.png" width="100">
  <h3 align="center"> Daily Routine </h3>
</p><br><br>

## Index
- [Index](#index)
- [OverView](#overview)
- [About The Project](#about-the-project)
  - [Main Component Used](#main-component-used)
  - [Learning Contents](#learning-contents)
  - [Result](#result)
<br><br><br>

## OverView
일정을 등록할 수 있으며, 카테고리별로 저장, 삭제 및 알림 등이 가능한 일정관리 Toy Project App.
<br>

## About The Project

<div align = "center">
<img src="https://user-images.githubusercontent.com/56511253/120450077-07b4d100-c3cb-11eb-82e7-e8327605c3cc.png" width = "20%">
&nbsp&nbsp&nbsp
<img src="https://images.velog.io/images/sangwoo24/post/56c3b64f-c6d5-4297-802b-f40bf2ba2e92/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202021-06-02%20at%2016.52.04.png" width = "20%">
&nbsp&nbsp&nbsp
<img src="https://images.velog.io/images/sangwoo24/post/fa12a7d9-9a0b-412c-b875-8d19f194e02a/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202021-06-02%20at%2016.52.07.png" width = "20%">
</div>

### Main Component Used
- MVVM Pattern
- TabBar, TableView, FSCalendarView(Library) ...
- Codable
<br>

### Learning Contents
- 하나의 모델을 여러가지 형태의 Object 로 만들어 필요한 곳에 쓰일 수 있도록 변형.
- 원하는 일정별로 Notification 구성.
- Codable 을 이용해 Custom Object에 대한 저장, 접근, 삭제 구현.
- 적절한 extenstion 을 사용하여 코드를 가독성 있도록 구성.
<br>

### Result
<div align="center"><a href="https://www.youtube.com/watch?v=MJP6pqCFX_M"target="_blank"><img src = "https://user-images.githubusercontent.com/56511253/120455961-279ac380-c3d0-11eb-84b5-92f53393b7b2.png"></a></div>
<br>

- 하나의 Model 을 각기 다른 형식으로 TableView 에 road 시켜야 했기 때문에, Model 을 여러 Object 로 만드는 과정에서 연산 복잡도가 늘어남.
- StoryBoard 와 Code 의 혼용으로 기능을 추가할 때 오히려 더 복잡해짐.
- Access Control 을 더욱 세밀하게 하지 못함.
