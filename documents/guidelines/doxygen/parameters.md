# Doxygen 매개변수 관리 가이드

이 문서는 Doxygen 설정 파일(`doxyfile`)의 주요 매개변수를 효과적으로 관리하기 위한 가이드입니다. 각 매개변수는 기능별로 그룹화되어 있으며, 명확한 이해를 돕기 위해 설명, 사용 가능한 값, 기본값 및 예제를 포함합니다.

이 설정 파일은 CMake와 같은 빌드 시스템과 연동하여 동적으로 변수를 설정하도록 설계되었습니다(`@VAR_NAME@` 형식 사용).
---

## Ⅰ. 기본 프로젝트 설정

이름, 버전, 설명과 같은 기본 프로젝트 정보를 설정합니다.

### `PROJECT_NAME`

- **설명**: 프로젝트의 이름을 지정합니다. 생성된 문서의 제목 및 헤더와 같은 다양한 위치에서 사용됩니다.
- **값**: 문자열 (빌드 시스템 변수 사용 권장)
- **기본값**: `"My Project"`
- **예제**: `PROJECT_NAME = "@PROJECT_NAME@"`

### `PROJECT_NUMBER`

- **설명**: 프로젝트의 버전 번호 또는 개정을 지정합니다.
- **값**: 문자열 (빌드 시스템 변수 사용 권장)
- **기본값**: (none)
- **예제**: `PROJECT_NUMBER = "@PROJECT_VERSION@"`

### `PROJECT_BRIEF`

- **설명**: 프로젝트의 한 줄 요약을 추가합니다. 각 문서 페이지 상단에 표시됩니다.
- **값**: 문자열 (빌드 시스템 변수 사용 권장)
- **기본값**: (none)
- **예제**: `PROJECT_BRIEF = "@PROJECT_설명@"`

### `OUTPUT_DIRECTORY`

- **설명**: 문서가 생성 될 최상위 디렉토리 경로를 지정합니다.
- **값**: 디렉토리 경로 (빌드 시스템 변수 사용 권장)
- **기본값**: (current directory)
- **예제**: `OUTPUT_DIRECTORY = "@DOXYGEN_OUTPUT_DIRECTORY@"`

### `OUTPUT_LANGUAGE`

- **설명**: 생성 된 문서의 언어를 선택합니다.
- **값**: `English`, `Korean`, `Japanese` 등과 같은 지원되는 언어
- **기본값**: `English`
- **예제**: `OUTPUT_LANGUAGE = English`

---

## Ⅱ. 소스 입력 및 분석 설정

문서화 할 소스 파일의 위치, 인코딩 및 추출 할 컨텐츠를 제어합니다.

### `INPUT`

- **설명**: 문서화 할 소스 파일 및 디렉토리 목록을 지정합니다.
- **값**: 파일 또는 디렉토리 경로 (빌드 시스템 변수 사용 권장)
- **기본값**: (none)
- **예제**: `INPUT = "@DOXYGEN_INPUT@"`

### `RECURSIVE`

- **설명**: `INPUT`에 지정된 디렉토리의 하위 디렉토리를 재귀적으로 검색할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `RECURSIVE = YES`

### `FILE_PATTERNS`

- **설명**: `INPUT` 디렉토리 내에서 검색할 파일 확장 패턴을 지정합니다.
- **값**: 와일드 카드 패턴 목록 (e.g., `*.cpp *.h`)
- **기본값**: (a variety of 기본값 extension patterns)
- **예제**: `FILE_PATTERNS = *.cpp *.h *.hpp`

### `EXCLUDE`

- **설명**: 문서에서 제외할 파일 또는 디렉토리 목록을 지정합니다.
- **값**: 파일 또는 디렉토리 경로 목록
- **기본값**: (none)
- **예제**: `EXCLUDE =`

### `INPUT_ENCODING`

- **설명**: 소스 파일의 문자 인코딩을 지정합니다.
- **값**: `UTF-8`,`EUC-KR` 등과 같은 `iconv`에 의해 지원되는 인코딩.
- **기본값**: `UTF-8`
- **예제**: `INPUT_ENCODING = UTF-8`

### `EXTRACT_ALL`

- **설명**: 문서 주석이 부족하더라도 모든 코드를 문서에 포함 시킬지 여부를 결정합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `EXTRACT_ALL = NO`

### `EXTRACT_PRIVATE`

- **설명**: 문서에 class 의 `private` 멤버를 포함할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `EXTRACT_PRIVATE = NO`

### `CPP_CLI_SUPPORT`

- **설명**: C++/CLI 구문을 지원할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `CPP_CLI_SUPPORT = YES`

---

## Ⅲ. 출력 형식 설정(HTML & LaTeX)

HTML 및 LaTeX 문서 생성과 관련된 옵션을 제어합니다.

### `GENERATE_HTML`

- **설명**: HTML 형식으로 문서를 생성할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GENERATE_HTML = YES`

### `HTML_OUTPUT`

- **설명**: 생성된 HTML 문서가 저장될 디렉토리 이름을 지정합니다.
- **값**: Directory name
- **기본값**: `html`
- **예제**: `HTML_OUTPUT = html`

### `GENERATE_TREEVIEW`

- **설명**: 내비게이션을 돕기 위해 트리 모양의 측면 패널을 생성할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `GENERATE_TREEVIEW = YES`

### `GENERATE_LATEX`

- **설명**: LaTeX 형식으로 문서를 생성할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GENERATE_LATEX = YES`

### `LATEX_OUTPUT`

- **설명**: 생성된 LaTeX 문서가 저장될 디렉토리 이름을 지정합니다.
- **값**: Directory name
- **기본값**: `latex`
- **예제**: `LATEX_OUTPUT = latex`

---

## Ⅳ. 다이어그램 및 그래프 설정 (Graphviz)

클래스 상속 계층 및 통화 그래프와 같은 시각적 다이어그램을 생성하기 위한 옵션을 제어합니다.

### `HAVE_DOT`

- **설명**: `dot` 도구를 사용하여 다이어그램을 생성할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `HAVE_DOT = YES`

### `UML_LOOK`

- **설명**: UML 스타일 클래스 다이어그램을 생성합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `UML_LOOK = YES`

### `GRAPHICAL_HIERARCHY`

- **설명**: 클래스 상속 계층의 그래픽 표현을 생성합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GRAPHICAL_HIERARCHY = YES`

### `DIRECTORY_GRAPH`

- **설명**: 디렉토리 구조를 보여주는 그래프를 생성합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `DIRECTORY_GRAPH = YES`

### `CALL_GRAPH`

- **설명**: 각 함수가 호출되는 다른 기능을 보여주는 호출 그래프를 생성합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `CALL_GRAPH = YES`

### `CALLER_GRAPH`

- **설명**: 어떤 다른 함수가 각 함수를 호출하는지 보여주는 호출자 그래프를 생성합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `CALLER_GRAPH = YES`

### `MAX_DOT_GRAPH_DEPTH`

- **설명**: 복잡성을 관리하기 위해 그래프의 최대 깊이를 제한합니다.
- **값**: Integer
- **기본값**: `0` (unlimited)
- **예제**: `MAX_DOT_GRAPH_DEPTH = 5`

### `DOT_IMAGE_FORMAT`

- **설명**: `dot`으로 생성 할 이미지 형식을 지정합니다.
- **값**: `png`, `svg`, `jpg` 등.
- **기본값**: `png`
- **예제**: `DOT_IMAGE_FORMAT = svg`

### `INTERACTIVE_SVG`

- **설명**: 형식이 `svg`인 경우 확대/축소 및 이동이 가능한 대화형 이미지를 만듭니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `INTERACTIVE_SVG = YES`

---

## Ⅴ. 경고 및 로깅 설정

문서 생성 프로세스 중에 발생하는 경고 메시지를 제어합니다.

### `QUIET`

- **설명**: 일반 메시지가 표준 출력으로 전송되는 것을 방지합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `QUIET = YES`

### `WARNINGS`

- **설명**: 경고 메시지를 활성화하거나 비활성화합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `WARNINGS = YES`

### `WARN_IF_UNDOCUMENTED`

- **설명**: 문서 주석이 없는 코드 요소에 대한 경고를 표시합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `WARN_IF_UNDOCUMENTED = YES`

### `WARN_LOGFILE`

- **설명**: 지정된 파일에 경고 및 오류 메시지를 씁니다.
- **값**: File path
- **기본값**: (none, outputs to stderr)
- **예제**: `WARN_LOGFILE = doxygen-warnings.log`

---

## Ⅵ. 고급 사용자 정의 설정

문서의 내용과 표현을 세부적으로 제어할 수 있는 고급 기능.

### `IMAGE_PATH`

- **설명**: 설명서에 사용된 이미지 파일을 찾을 수 있는 추가 경로를 지정합니다.
- **값**: List of directory paths
- **기본값**: (none)
- **예제**: `IMAGE_PATH =`

### `INCLUDE_PATH`

- **설명**: 소스 코드에서 `#include`가 참조하는 헤더 파일의 경로를 지정합니다.
- **값**: List of directory paths
- **기본값**: (none)
- **예제**: `INCLUDE_PATH =`

### `PREDEFINED`

- **설명**: 소스 코드 분석 전에 정의할 전처리기 매크로를 설정합니다.
- **값**: List in the format `macro` or `macro=definition`
- **기본값**: (none)
- **예제**: `PREDEFINED =`

### `EXCLUDE_SYMBOLS`

- **설명**: 문서에서 특정 패턴과 일치하는 기호를 제외합니다.
- **값**: List of symbol name patterns
- **기본값**: (none)
- **예제**: `EXCLUDE_SYMBOLS =`

### `ALIASES`

- **설명**: 자주 사용되는 Doxygen 명령을 사용자 고유의 간단한 명령으로 대체합니다.
- **값**: List in the format `name=definition`
- **기본값**: (none)
- **예제**: `ALIASES =`

### `TAGFILES`

- **설명**: 다른 Doxygen 프로젝트의 태그 파일을 연결하여 외부 문서 링크를 만듭니다.
- **값**: List in the format `tagfile=documentation_location`
- **기본값**: (none)
- **예제**: `TAGFILES =`

### `SORT_MEMBER_DOCS`

- **설명**: 문서에 표시될 때 클래스 멤버의 정렬 순서를 제어합니다.
- **값**: `YES` (alphabetical order) | `NO` (declaration order)
- **기본값**: `YES`
- **예제**: `SORT_MEMBER_DOCS = NO`

### `FULL_PATH_NAMES`

- **설명**: 파일 목록에 전체 경로를 표시할지 여부를 결정합니다. `STRIP_FROM_PATH`와 함께 사용됩니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `FULL_PATH_NAMES = YES`

### `STRIP_FROM_PATH`

- **설명**: `FULL_PATH_NAMES`가 `YES`인 경우, 지정된 부분을 파일 경로에서 제거하여 상대 경로처럼 보이게 합니다.
- **값**: Path to remove (빌드 시스템 변수를 사용하는 것이 좋음)
- **기본값**: (doxygen execution directory)
- **예제**: `STRIP_FROM_PATH = "@PROJECT_SOURCE_DIR@"`

---

## Ⅶ. 특수 목록 생성 옵션

`\todo` 및 `\bug`와 같은 특정 명령을 기반으로 특수 목록 페이지를 생성합니다.

### `GENERATE_TODOLIST`

- **설명**: `\todo` 명령으로 작성된 내용을 수집하여 '할 일 목록' 페이지를 만듭니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GENERATE_TODOLIST = YES`

### `GENERATE_TESTLIST`

- **설명**: `\test` 명령어로 작성된 내용을 수집하여 '테스트 목록' 페이지를 생성합니다..
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GENERATE_TESTLIST = YES`

### `GENERATE_BUGLIST`

- **설명**: `\bug` 명령으로 작성된 내용을 수집하여 '버그 목록' 페이지를 만듭니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GENERATE_BUGLIST = YES`

### `GENERATE_DEPRECATEDLIST`

- **설명**: `\deprecated` 명령으로 작성된 콘텐츠를 수집하여 '사용 중단된 API 목록' 페이지를 만듭니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `GENERATE_DEPRECATEDLIST = YES`

---

## Ⅷ. 소스 탐색 옵션

생성된 문서 내에서 소스 코드를 직접 탐색하는 것과 관련된 옵션을 구성합니다.

### `SOURCE_BROWSER`

- **설명**: 각 문서화된 파일과 멤버의 소스 코드를 볼 수 있는 기능을 활성화합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `SOURCE_BROWSER = YES`

### `INLINE_SOURCES`

- **설명**: 멤버의 소스 코드를 자세한 설명 섹션에 직접 삽입합니다. `SOURCE_BROWSER`를 활성화해야 합니다.
- **값**: `YES | NO`
- **기본값**: `NO`
- **예제**: `INLINE_SOURCES = YES`

### `STRIP_CODE_COMMENTS`

- **설명**: 소스 브라우저에 표시된 코드에서 주석을 제거할지 여부를 설정합니다.
- **값**: `YES | NO`
- **기본값**: `YES`
- **예제**: `STRIP_CODE_COMMENTS = YES`
