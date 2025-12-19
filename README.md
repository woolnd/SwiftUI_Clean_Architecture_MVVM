# 🐱 Cat Random Photo App

SwiftUI와 Clean Architecture + MVVM + Coordinator 패턴을 결합한 고양이 랜덤 사진 앱입니다.

## 📖 프로젝트 소개

이 프로젝트는 Clean Architecture를 학습하기 위해 만들어진 샘플 애플리케이션입니다. [Cat as a Service (CATAAS)](https://cataas.com/) API를 활용하여 귀여운 고양이 사진을 랜덤으로 보여줍니다.

## 🎯 주요 기능

### 📷 단일 사진 뷰 (CatPhotoView)
- 랜덤 고양이 사진 불러오기
- Pull-to-refresh로 새로운 사진 불러오기
- 로딩 상태 표시
- 에러 핸들링

### 📱 피드 뷰 (CatFeedView)
- 무한 스크롤 방식의 고양이 피드
- 페이지네이션을 통한 효율적인 데이터 로딩
- 각 아이템별 독립적인 이미지 캐싱
- 스켈레톤 UI를 통한 로딩 상태 표시

## 🏗️ 아키텍처

### Clean Architecture + MVVM + Coordinator

프로젝트는 다음과 같은 레이어와 패턴으로 구성되어 있습니다:

#### **Presentation Layer (MVVM + Coordinator)**
- **View**: SwiftUI로 구현된 UI 컴포넌트
- **ViewModel**: View의 비즈니스 로직 처리 및 상태 관리
- **Coordinator**: 화면 전환 로직 분리 및 Flow 관리
  - MainFlowCoordinator
  - MainRoute
  - MainViewActions

#### **Domain Layer**
- **Entities**: 비즈니스 모델 (CatPhoto, CatFeed)
- **Use Cases**: 애플리케이션의 비즈니스 규칙
  - FetchCatPhotoUseCase
  - FetchCatFeedUseCase
- **Repository Interfaces**: 데이터 접근을 위한 추상화

#### **Data Layer**
- **Repository Implementations**: Domain의 Repository 인터페이스 구현
  - DefaultCatPhotoRepository
  - DefaultCatFeedRepository
- **Data Sources**: API 통신을 위한 네트워크 레이어
- **DTOs**: 데이터 전송 객체 및 매핑

#### **Infrastructure Layer**
- **Network**: API 통신을 위한 공통 인프라
  - APIClient
  - Endpoint
  - APIError

#### **Common Layer**
- **Utilities**: 공통으로 사용되는 유틸리티
  - Cancellable
  - CatImageLoader (다운샘플링)
  - SkeletonView
  - EmptyView

```
┌─────────────────────────────────────────────────┐
│   Presentation (SwiftUI + MVVM + Coordinator)   │
│   ┌──────────┐  ┌────────────┐  ┌────────────┐ │
│   │   View   │─▶│ ViewModel  │◀─│Coordinator │ │
│   └──────────┘  └────────────┘  └────────────┘ │
└─────────────┬───────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────┐
│              Domain Layer                       │
│   ┌──────────┐      ┌────────────┐             │
│   │ Entities │      │  Use Cases │             │
│   └──────────┘      └────────────┘             │
│          ┌────────────────┐                    │
│          │  Repository    │                    │
│          │  (Interface)   │                    │
│          └────────────────┘                    │
└─────────────┬───────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────┐
│              Data Layer                         │
│   ┌──────────────────────────────────────────┐ │
│   │     Repository Implementation            │ │
│   └──────────────────────────────────────────┘ │
│   ┌──────────┐      ┌─────────────────────┐  │
│   │   DTOs   │      │   Data Mapping      │  │
│   └──────────┘      └─────────────────────┘  │
└─────────────┬───────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────┐
│           Infrastructure Layer                  │
│   ┌──────────┐  ┌───────────┐  ┌────────────┐ │
│   │APIClient │  │ Endpoint  │  │  APIError  │ │
│   └──────────┘  └───────────┘  └────────────┘ │
└─────────────────────────────────────────────────┘
```

## ⚡️ 성능 최적화

### 이미지 다운샘플링
- 메모리 효율을 위해 실제 표시 크기에 맞춰 이미지 리사이징
- CatImageLoader를 통한 최적화된 이미지 로딩

### 2단계 캐싱 전략
- **메모리 캐시 (NSCache)**: 빠른 액세스를 위한 1차 캐시
- **디스크 캐시 (FileManager)**: 앱 재시작 후에도 유지되는 2차 캐시
- 캐시 키 관리 및 효율적인 메모리 관리

### 비동기 처리
- URLSession을 활용한 백그라운드 이미지 다운로드
- async/await를 활용한 비동기 작업 처리
- Combine을 활용한 반응형 데이터 바인딩

## 🛠️ 기술 스택

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: Clean Architecture + MVVM + Coordinator
- **Networking**: URLSession
- **Async**: async/await, Combine
- **Image Optimization**: 
  - 다운샘플링 (UIGraphicsImageRenderer)
  - 메모리 캐시 (NSCache)
  - 디스크 캐시 (FileManager)
- **Dependency Injection**: Manual DI (DIContainer)
- **API**: [CATAAS API](https://cataas.com/)

## 📋 요구사항

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## 🚀 시작하기

### 설치

```bash
# 저장소 클론
git clone https://github.com/woolnd/SwiftUI_Clean_Architecture_MVVM.git

# 프로젝트 디렉토리로 이동
cd SwiftUI_Clean_Architecture_MVVM

# Xcode에서 프로젝트 열기
open SwiftUI_Clean_Architecture_MVVM.xcodeproj
```

### 실행

1. Xcode에서 프로젝트를 엽니다
2. 시뮬레이터 또는 실제 기기를 선택합니다
3. `Cmd + R`을 눌러 빌드 및 실행합니다

## 📁 프로젝트 구조

```
SwiftUI_Clean_Architecture_MVVM/
├── App/
│   ├── AppFlowCoordinator.swift
│   ├── SwiftUI_Clean_Architecture_MVVMApp.swift
│   ├── MainFlowRootView.swift
│   └── DIContainer/
│       ├── AppDIContainer.swift
│       ├── MainSceneDIContainer.swift
│       ├── CatPhotoSceneDIContainer.swift
│       └── CatFeedSceneDIContainer.swift
│
├── Presentation/
│   └── Flows/
│       ├── MainFlowCoordinator.swift
│       ├── MainRoute.swift
│       ├── MainViewActions.swift
│       └── MainView/
│           └── MainView.swift
│   └── CatPhotoView/
│       ├── CatPhotoView.swift
│       └── CatPhotoViewModel.swift
│   └── CatFeedView/
│       ├── CatFeedView.swift
│       ├── CatFeedViewModel.swift
│       └── CatFeedItemView.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── CatPhoto.swift
│   │   └── CatFeed.swift
│   ├── UseCases/
│   │   ├── Protocol/
│   │   │   └── UseCase.swift
│   │   ├── FetchCatPhotoUseCase.swift
│   │   └── FetchCatFeedUseCase.swift
│   └── Repositories/
│       ├── CatPhotoRepository.swift
│       └── CatFeedRepository.swift
│
├── Data/
│   ├── Network/
│   │   ├── DataMapping/
│   │   │   ├── CatPhotoDTO/
│   │   │   │   ├── CatPhotoRequestDTO+Mapping.swift
│   │   │   │   └── CatPhotoResponseDTO+Mapping.swift
│   │   │   ├── CatFeedDTO/
│   │   │   │   ├── CatFeedRequestDTO+Mapping.swift
│   │   │   │   └── CatFeedResponse+Mapping.swift
│   │   │   └── APIEndpoints.swift
│   └── Repositories/
│       ├── DefaultCatPhotoRepository.swift
│       └── DefaultCatFeedRepository.swift
│
├── Infrastructure/
│   └── Network/
│       ├── APIError.swift
│       ├── Endpoint.swift
│       └── APIClient.swift
│
├── Common/
│   ├── Cancellable.swift
│   ├── CatImageLoader.swift
│   ├── SkeletonView.swift
│   └── EmptyView.swift
│
└── Resources/
    └── Assets.xcassets
```

## 🔗 API 엔드포인트

이 앱은 다음 CATAAS API를 사용합니다:

- 랜덤 고양이 사진: `GET https://cataas.com/cat`
- 태그별 고양이 사진: `GET https://cataas.com/cat/{tag}`
- 텍스트가 포함된 고양이 사진: `GET https://cataas.com/cat/says/{text}`

더 자세한 API 문서는 [CATAAS 공식 사이트](https://cataas.com/)를 참고하세요.

## 🎓 학습 포인트

이 프로젝트를 통해 다음을 학습할 수 있습니다:

### 아키텍처
1. **관심사의 분리**: 각 레이어가 명확한 책임을 가집니다
2. **의존성 규칙**: 외부 레이어가 내부 레이어에 의존하며, 그 반대는 성립하지 않습니다
3. **의존성 주입**: DIContainer를 통한 느슨한 결합
4. **Coordinator 패턴**: 화면 전환 로직을 ViewModel에서 분리

### 데이터 관리
5. **DTO 패턴**: API 응답과 Domain Entity의 분리
6. **Repository 패턴**: 데이터 소스 추상화

### 성능 최적화
7. **이미지 다운샘플링**: 메모리 효율적인 이미지 처리
8. **다층 캐싱 전략**: 
   - 메모리 캐시 (NSCache): 빠른 접근을 위한 1차 캐시
   - 디스크 캐시 (FileManager): 앱 재시작 후에도 유지되는 2차 캐시
9. **비동기 처리**: async/await와 Combine을 활용한 효율적인 비동기 작업

### 테스트 용이성
10. **프로토콜 기반 설계**: Mock 객체를 활용한 단위 테스트 가능
11. **각 레이어의 독립성**: 레이어별 독립적인 테스트 가능

## 🧪 테스트

```bash
# 유닛 테스트 실행
Cmd + U
```

### 테스트 가능한 영역
- Use Cases 단위 테스트
- Repository 단위 테스트 (Mock API 활용)
- ViewModel 단위 테스트 (Mock Use Case 활용)

## 🔄 확장 가능성

이 아키텍처를 통해 다음과 같은 확장이 용이합니다:

- ✅ 새로운 화면 추가 (새로운 Scene DIContainer 생성)
- ✅ API 변경 또는 교체 (Repository만 수정)
- ✅ 로컬 데이터베이스 추가 (새로운 DataSource 추가)
- ✅ 이미지 캐싱 전략 변경 (CatImageLoader만 수정)
- ✅ UI 프레임워크 변경 (Presentation Layer만 수정)

## 👤 작성자

**엄재웅**
- GitHub: [@woolnd](https://github.com/woolnd)

## 📝 라이센스

이 프로젝트는 학습 목적으로 작성되었습니다.

## 🙏 감사의 말

- [CATAAS](https://cataas.com/) - 고양이 사진 API 제공
- Clean Architecture 개념을 제시한 Robert C. Martin (Uncle Bob)
- SwiftUI 커뮤니티의 많은 개발자분들

---

⭐️ 이 프로젝트가 도움이 되었다면 Star를 눌러주세요!
