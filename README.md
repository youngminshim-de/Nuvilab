# Nuvilab

도서검색 앱

## Minimum DeployMent Target
- iOS: 17.5+

## Framework
- [Moya](https://github.com/Moya/Moya)
- [Alamofire](https://github.com/Alamofire/Alamofire)


## Description
- SwiftUI App
- MVVM Architecture
- SwiftConcurrency, Moya 를 이용한 Networking 구현
- Searchable을 이용한 검색 기능 구현
- CoreData를 이용한 오프라인 모드 지원

## 기능    
- 도서 목록 가져오기 (Pagination)
  - [x] Anchor 누르면 해당 부분으로 Scrolling

- 검색 (Searchable)
  - [x] 현재 UI에 노출되어있는 도서 목록 검색 기능
 
- CoreData
  - [x] Networking을 통해 Data가 update되면 CoreData에 반영
  - [x] 오프라인이거나, 네트워크가 불안정할 경우 CoreData Fetch하여 UI 반영
  - [x] 네트워크 요청과 마찬가지로 Pagination 처리
 
- 오프라인 모드
  - [x] NWPathMonitor를 이용하여 오프라인 모드 Check   

- Error Handling
  - [x] 재시도 로직 (지수백오프 알고리즘, retryLimit: 2)


## 성능최적화 방안

### 이슈 1: URLSession을 사용한 API 요청 시 데이터 변환 오류 발생

상황: API에서 JSON Data를 받을 때, 서버 응답의 데이터 구조가 변경되었거나 필드가 누락되면서 데이터 변환 중 예외가 발생함

해결
- 최우선적으로 앱이 비정상종료 되지 않도록 한다. (프로퍼티 Optional 처리, 기본 값 설정 등)
- UI에 있어 크리티컬한 필드가 아니라면 해당부분을 제외하고, UI를 그린다.
- 크리티컬한 필드라면 오류메세지를 보여준다.



### 이슈 2: 네트워크 연결 불안정 시 앱의 비정상 종료

상황: 사용자가 네트워크가 불안정한 환경에서 앱을 사용할 때, API 호출이 실패하고 앱이 비정상 종료되는 문제가 발생함

해결
- 지수 백오프 알고리즘을 이용하여 재시도 한다. (retryLimit: 2, delay: 3sec 로 설정)
  - retryLimit 설정이유
    1. 화면에 아무런 반응없이 3초이상 지속되면 사용자 이탈 급상승
    2. 계속해서 재시도를 하기에는 비용, Resoure 낭비가 심하고 사용자 이탈도 심하기에 2번까지만 재시도
- 이후 Error Alert 표시 후, CoreData Fetch하여 오프라인 모드로 UI 반영



### 이슈 3: 대량의 데이터를 List에 표시 시 성능 저하

상황: API에서 대량의 데이터를 가져와 SwiftUI List에 표시할 때, 스크롤이 끊기거나 앱이 느려지는 문제가 발생함

해결
- VStack -> LazyStack 으로 변경 (VStack은 화면에 보여지지 않는 Cell까지 모두 처리하는 반면, LazyVStack은 화면에 보여지는 Cell만 처리하여 성능을 향상 시킬 수 있다.)
- Pagination : Pagination처리를 하여 한번에 모든 데이터를 가져오지 않고, 적당한 Data만을 받아와 UI 성능을 향상 시킬 수 있다.
- Disappear 이용: 빠르게 스크롤 시, disappear되는 Cell에서 처리되는 작업을 취소시켜 불필요한 작업을 최소화 하여 성능을 향상 시킬 수 있다.
  
(Ex: KingFisher를 이용하여 Image Download 시, cancelOnDisapper를 이용하여 이미지 다운로드를 취소시켜 성능을 향상 시킬 수 있다.)
		

  
## 참고
- SPM 관련 Build Error가 발생한다면, Package.resolved를 지우고 다시 빌드해주세요.
  (Nuvilab.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved)
