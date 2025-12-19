# 🐱 Cat Random Photo App

SwiftUI와 Clean Architecture + MVVM 패턴을 결합한 고양이 랜덤 사진 앱입니다.

## 📖 프로젝트 소개

이 프로젝트는 Clean Architecture를 학습하기 위해 만들어진 샘플 애플리케이션입니다. [Cat as a Service (CATAAS)](https://cataas.com/) API를 활용하여 귀여운 고양이 사진을 랜덤으로 보여줍니다.

## 🏗️ 아키텍처

### Clean Architecture + MVVM

프로젝트는 다음과 같은 레이어로 구성되어 있습니다:

**Presentation Layer (MVVM)**
- View: SwiftUI로 구현된 UI 컴포넌트
- ViewModel: View의 비즈니스 로직 처리 및 상태 관리

**Domain Layer**
- Entities: 비즈니스 모델
- Use Cases: 애플리케이션의 비즈니스 규칙
- Repository Interfaces: 데이터 접근을 위한 추상화

**Data Layer**
- Repository Implementations: Domain의 Repository 인터페이스 구현
- Data Sources: API, Local DB 등 실제 데이터 소스
- DTOs: 데이터 전송 객체

```
┌─────────────────────────────────────┐
│     Presentation (SwiftUI + MVVM)   │
│   ┌──────────┐      ┌────────────┐ │
│   │   View   │─────▶│ ViewModel  │ │
│   └──────────┘      └────────────┘ │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│          Domain Layer               │
│   ┌──────────┐      ┌────────────┐ │
│   │ Entities │      │  Use Cases │ │
│   └──────────┘      └────────────┘ │
│          ┌────────────────┐        │
│          │  Repository    │        │
│          │  (Interface)   │        │
│          └────────────────┘        │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│          Data Layer                 │
│   ┌──────────────────────────────┐ │
│   │  Repository Implementation   │ │
│   └──────────────────────────────┘ │
│   ┌──────────┐      ┌────────────┐ │
│   │   API    │      │ Local DB   │ │
│   │ DataSource│     │ DataSource │ │
│   └──────────┘      └────────────┘ │
└─────────────────────────────────────┘
```

## 🎯 주요 기능

- 랜덤 고양이 사진 불러오기
- 고양이 사진 새로고침
- 이미지 캐싱 처리 (메모리 & 디스크)
- 로딩 상태 표시
- 에러 핸들링

## 🛠️ 기술 스택

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: Clean Architecture + MVVM
- **Networking**: URLSession
- **Image Caching**: NSCache (Memory) + FileManager (Disk)
- **Dependency Injection**: (사용한 DI 라이브러리 또는 수동 DI 명시)
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
│   └── DIContainer/
│       ├── AppDIContainer.swift
│       └── CatPhotoSceneDIContainer.swift
├── Presentation/
│   └── CatPhotoView/
│       ├── CatPhotoViewModel.swift
│       └── CatPhotoView.swift
├── Domain/
│   ├── Entities/
│   │   └── CatPhoto.swift
│   ├── UseCases/
│   │   ├── Protocol/
│   │   │   └── UseCase.swift
│   │   └── FetchCatPhotoUseCase.swift
│   └── Repositories/
│       └── CatPhotoRepository.swift
├── Data/
│   ├── Network/
│   │   ├── DataMapping/
│   │   │   ├── CatPhotoRequestDTO+Mapping.swift
│   │   │   ├── CatPhotoResponseDTO+Mapping.swift
│   │   │   └── APIEndpoints.swift
│   │   └── Cache/
│   │       └── ImageCache.swift
│   └── Repositories/
│       └── DefaultCatPhotoRepository.swift
├── Infrastructure/
│   └── Network/
│       ├── APIError.swift
│       ├── Endpoint.swift
│       └── APIClient.swift
├── Common/
│   └── Cancellable.swift
└── Resources/
    └── Assets.xcassets
```

## 🔗 API 엔드포인트

이 앱은 다음 CATAAS API를 사용합니다:

- 랜덤 고양이 사진: `https://cataas.com/cat`
- 태그별 고양이 사진: `https://cataas.com/cat/{tag}`
- 텍스트가 포함된 고양이 사진: `https://cataas.com/cat/says/{text}`

더 자세한 API 문서는 [CATAAS 공식 사이트](https://cataas.com/)를 참고하세요.

## 🎓 학습 포인트

이 프로젝트를 통해 다음을 학습할 수 있습니다:

1. **관심사의 분리**: 각 레이어가 명확한 책임을 가집니다
2. **의존성 규칙**: 외부 레이어가 내부 레이어에 의존하며, 그 반대는 성립하지 않습니다
3. **테스트 용이성**: 각 레이어를 독립적으로 테스트할 수 있습니다
4. **유연성**: 구현체를 쉽게 교체할 수 있습니다 (예: API → Local DB)
5. **이미지 캐싱 전략**: 
   - 메모리 캐시 (NSCache): 빠른 접근을 위한 1차 캐시
   - 디스크 캐시 (FileManager): 앱 재시작 후에도 유지되는 2차 캐시
   - 캐시 키 관리 및 만료 정책

## 🧪 테스트

```bash
# 유닛 테스트 실행
Cmd + U
```

## 👤 작성자

**엄재웅**
- GitHub: [@woolnd](https://github.com/woolnd)

## 🙏 감사의 말

- [CATAAS](https://cataas.com/) - 고양이 사진 API 제공
- Clean Architecture 개념을 제시한 Robert C. Martin (Uncle Bob)

---

⭐️ 이 프로젝트가 도움이 되었다면 Star를 눌러주세요!
