# dajimCard iOS App

오늘의 다짐과 학습 계획을 카드 형태로 저장할 수 있는 iOS 애플리케이션입니다.

---
## Stacks 🐈
### Environment
<img src="https://img.shields.io/badge/Xcode-1575F9.svg?style=for-the-badge&logo=Xcode&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> <img src="https://img.shields.io/badge/macOS-000000.svg?style=for-the-badge&logo=apple&logoColor=white">

### Development
<img src="https://img.shields.io/badge/Swift-F05138.svg?style=for-the-badge&logo=swift&logoColor=white"> <img src="https://img.shields.io/badge/iOS-000000.svg?style=for-the-badge&logo=apple&logoColor=white"> <img src="https://img.shields.io/badge/UIKit-2396F3.svg?style=for-the-badge&logo=apple&logoColor=white"> <img src="https://img.shields.io/badge/MVC%20Pattern-4285F4.svg?style=for-the-badge&logo=google&logoColor=white">   

### OS
<img src="https://img.shields.io/badge/macOS-000000.svg?style=for-the-badge&logo=apple&logoColor=white">

### Communication
<img src="https://img.shields.io/badge/notion-000000?style=for-the-badge&logo=notion&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white">

---
## 화면 구성

|메인 페이지|입력 모달창|
|---|---|
|<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-20 at 20 15 40" src="https://github.com/user-attachments/assets/570d4b49-8dd4-403c-97c1-42732c72b16c" />|<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-20 at 20 16 32" src="https://github.com/user-attachments/assets/e003c6a5-5ffa-472c-bd04-694eb21810a1" />|
|<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-20 at 20 16 45" src="https://github.com/user-attachments/assets/dd30bcb5-bb2a-496c-a146-e9d93b586624" />||


---
## 주요 기능 

### ☑️ 다짐 카드 작성 및 저장
- Entry 구조체를 사용해서 제목,내용, 이미지, 생성일 관리
- 입력한 다짐은 EntryEditorViewController를 통해 메인 화면의 UICollectionView에 반영됨
  
### ☑️ 이미지 선택 및 커스텀 
- iOS 기본 PHPicker(사진 선택기) 사용해서 카드별 이미지 지정 가능
- PHPicker를 통해 메인 페이지의 배경 이미지 변경 가능

