# SceneAware
SceneAware는 교통 상황을 인지하는 **Scene-level Calssification 시스템** 입니다.
비디오에서 장면을 추출하고, 이를 분류하여 교통 사고, 정체, 정상 주행 등의 상황을 실시간으로 감지합니다.

## 프로젝트 특징
- PyTorch 기반 Scene Classifier 모델 학습
- ONNX로 변환 후 TensorRT 엔진 생성
- TensorRT 기반 고성능 C++ 추론 파이프라인
- GTest 기반 유닛 테스트 환경 구성
- 실시간 또는 저장된 영상 입력 처리 가능
- 프로젝트 초기 설정 자동화

## 디렉토리 구조
```
SceneAware/
├── applications/
│   └── scene_aware_main/            # 최종 실행 프로그램 소스
├── libraries/
│   ├── inference/                   # TensorRT 추론 모듈
│   ├── math/                        # 수학/통계 유틸 함수
│   ├── string_utils/                # 문자열 처리 유틸
│   └── utils/                       # 공통 기능 유틸
├── datasets/
│   ├── raw_videos/                  # 원본 영상 (class별 폴더로 분류됨)
│   │   ├── accident/
│   │   ├── construction/
│   │   ├── normal/
│   │   └── police/
│   ├── sceneaware_small/            # 훈련/검증용 샘플 (train/val로 나뉨)
│   └── train/                       # 전체 데이터셋 (클래스별 이미지 분할)
├── scripts/
│   ├── executable/                  # 전체 초기화 스크립트 (`init.sh`)
│   ├── features/git/                # git hooks 설정
│   ├── setup/                       # 파이썬 가상환경 설정
│   └── train/                       # 학습 / 전처리 / 변환 스크립트
│       ├── extract_frame.py
│       ├── split_train_valid.sh
│       ├── train_scene_classifier.py
│       ├── export_onnx_resnet18.py
│       └── build_tensorrt_engine.py
├── cmake/                           # CMake 모듈 템플릿들
├── externals/                       # 외부 라이브러리 소스
├── install/                         # 외부 라이브러리 설치 디렉터리
├── model/                           # 학습된 모델 및 ONNX, engine 저장 경로
├── build/                           # CMake 빌드 출력 경로
└── CMakeLists.txt                   # 최상위 CMake 엔트리
```

## 전체 워크플로우 (데이터 → 학습 → 추론)
### 1. 환경 초기화
```
./scripts/executable/init.sh
```

### 2. 영상에서 프레임 추출
- **설명**: 폴더 디렉토리를 읽어서 각 클래스별 '.h264' 영상을 일정 간격으로 잘라 '.jpg' 이미지 생성
- **Input**: `datasets/raw_videos`
- **Output**: `datasets/train/{class}/*.jpg`

```
python scripts/train/extract_frame.py \
    --input_root ./datasets/raw_videos \
    --output_root ./datasets/train \
    --frame_interval 15
```

### 3. 학습/검증 데이터셋 분할
- **설명**: 클래스별 이미지 중 80%는 학습용, 20%는 검증용으로 복사
- **Input**: `datasets/train`
- **Output**
    - 학습 이미지: `datasets/sceneaware_small/train/{class}/*.jpg`
    - 검증 이미지: `datasets/sceneaware_small/val/{class}/*.jpg`
```
./scripts/train/split_train_vaild.sh
```

### 4. 모델 학습 (PyTorch 기반 전이학습)
- **설명**: `ResNet18` 사전 학습 모델을 기반으로, **마지막 분류층만 학습하는 전이학습**을 수행
- **Input**
    - 학습 이미지: `datasets/sceneaware_small/train/{class}/*.jpg`
    - 검증 이미지: `datasets/sceneaware_small/val/{class}/*.jpg`
- **Output**: `model/scene_classifier.pt`

```
python scripts/train/train_scene_classifier.py \
  --train_dir datasets/sceneaware_small/train \
  --val_dir datasets/sceneaware_small/val \
  --epochs 10 \
  --batch_size 16 \
  --lr 1e-4 \
  --num_workers 4 \
  --output model/scene_classifier.pt
```

### 5. ONNX 변환
- **설명**: PyTorch 모델을 ONNX 포맷으로 변환
- **Input**: `model/scene_classifier.pt`
- **Output**: `model/scene_classifier.onnx`

```
python script/train/export_onnx_resnet18.py
  --pt model/scene_classifier.pt \
  --output model/scene_classifier.onnx \
  --imgsz 224
```

### 6. TensorRT 엔진 생성
- **설명**: ONNX 모델을 최적화된 TensorRT 엔진으로 컴파일
- **Input**: `model/scene_classifier.onnx`
- **Output**: `model/scene_classifier.engine`

```
python scripts/train/build_tensorrt_engine.py \
   --onnx model/scene_classifier.onnx \
   --output model \
   --fp32 \
   --workspace 4096
```

### 7. C++ 추론 실행
- **설명**: 
- **Input**: 
- **Output**: 

### 8. 단위 테스트 (Gtest)
```

```

## Requirements
- CMake ≥ 3.15
- C++17-compatible compiler (GCC, Clang, MSVC)
- Python ≥ 3.8
- PyTorch
- OpenCV (Python + C++)
- TensorRT
- FFmpeg
- Git
- Bash (for scripts)

## 빌드 방법
SceneAware는 CMake 기반의 C++ 프로젝트이며, 동적(shared) 또는 정적(static) 라이브러리로 빌드할 수 있습니다.

### 기본 빌드 명령어
```
# 동적 라이브러리(shared object) 빌드
cmake -B build -DBUILD_SHARED_LIBS=ON
cmake --build build

# 정적 라이브러리(static archive) 빌드
cmake -B build -DBUILD_SHARED_LIBS=OFF
cmake --build build
```

### 빌드 출력 경로
- 실행 파일: `build/applications/scene_aware_main/`
- 라이브러리: `build/libraries/`
- 테스트 바이너리: `build/libraries/<module>/test/`

## License
MIT License.

## Contact
For questions for contributions:
- GitHub: [ultramuk/scene_aware](https://github.com/ultramuk/scene_aware)
