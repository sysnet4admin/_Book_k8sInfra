<div align="center">

# 요즘 개발자를 위한 쿠버네티스/도커

<a href="https://product.kyobobook.co.kr/detail/S000221973541">
<img src="https://contents.kyobobook.co.kr/pdt/9791140721351.jpg" width="360">
</a>

<br/>
<br/>

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
![Harbor](https://img.shields.io/badge/Harbor-60B932?style=flat-square&logo=harbor&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat-square&logo=helm&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white)
![Vagrant](https://img.shields.io/badge/Vagrant-1868F2?style=flat-square&logo=vagrant&logoColor=white)
<br/>
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat-square&logo=grafana&logoColor=white)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-425CC7?style=flat-square&logo=opentelemetry&logoColor=white)
![Argo](https://img.shields.io/badge/Argo_CD_%2F_Rollouts-EF7B4D?style=flat-square&logo=argo&logoColor=white)
![Cilium](https://img.shields.io/badge/Cilium-8061A9?style=flat-square&logo=cilium&logoColor=white)
![Ollama](https://img.shields.io/badge/Ollama-000000?style=flat-square&logo=ollama&logoColor=white)

</div>

> 🔔 **알림1(진행 중):** macOS 26.7 이상을 비롯한 일부 버전에서는 책대로 설치한 베이그런트(Vagrant) 2.4.9로 가상 머신을 만들면 SSH 포트가 Vagrantfile에 지정한 번호(cp-k8s는 60010)가 아닌 다른 번호(2250 등)로 바뀌어서 타비(Tabby)로 가상 머신에 접속되지 않습니다(윈도와 리눅스에는 영향이 없습니다). 해결 방법 2가지와 함께 지킬 사항, 진행 상황은 [이슈 #48](../../issues/48)에서 확인하실 수 있습니다.

이 저장소는 [요즘 개발자를 위한 쿠버네티스/도커](https://product.kyobobook.co.kr/detail/S000221973541) 책의 실습을 위한 코드를 제공합니다.

베이그런트로 만든 가상 머신 위에 쿠버네티스 클러스터를 직접 구성하고, 도커와 하버, 젠킨스, 프로메테우스와 그라파나 제품군을 실습합니다. 7장에서는 오퍼레이터 패턴, 오픈텔레메트리, 아르고 CD와 아르고 롤아웃, 소형 LLM까지 다룹니다.

---

## 제공되는 장별 실습 코드

| 경로 | 장 | 실습 내용 |
|------|----|-----------|
| [ch2](ch2/) | <small>테스트 환경 구성하기</small> | <small>가상 머신을 만드는 Vagrantfile과 프로비저닝 스크립트, macOS용 버추얼박스, 베이그런트, 타비 설치 파일</small> |
| [ch3](ch3/) | <small>컨테이너를 다루는 표준 아키텍처, 쿠버네티스</small> | <small>쿠버네티스 클러스터 구성 파일과 워크로드, 서비스(노드포트, 로드밸런서, 게이트웨이), 스토리지, HPA 실습 파일</small> |
| [ch4](ch4/) | <small>쿠버네티스를 이루는 컨테이너 도우미, 도커와 하버</small> | <small>네 가지 방법으로 이미지를 빌드하는 예제, 하버 레지스트리 구성 스크립트, 3장에서 사용한 이미지의 소스</small> |
| [ch5](ch5/) | <small>지속적인 통합과 배포 자동화, 젠킨스</small> | <small>커스터마이즈와 헬름 예제, 헬름으로 젠킨스를 설치하는 스크립트, Freestyle과 깃옵스 실습 파일</small> |
| [ch6](ch6/) | <small>안정적인 운영을 완성하는 모니터링, 프로메테우스와 그라파나 제품군</small> | <small>프로메테우스, 그라파나, 얼럿매니저 설치 스크립트와 대시보드, 로키, 템포, 파이로스코프 실습 파일</small> |
| [ch7](ch7/) | <small>컨테이너 인프라의 활용을 확장하는 도구들, 종합</small> | <small>7장용 클러스터 구성 파일, 헤드램프, 실리움 네트워크 정책, 프로메테우스 오퍼레이터, 오픈텔레메트리 콜렉터, 아르고 CD와 아르고 롤아웃, 소형 LLM 실습 파일</small> |
| [app/A.console-k8s](app/A.console-k8s/) | <small>부록 A. 쿠버네티스 콘솔 노드</small> | <small>클러스터 밖에서 kubectl로 명령을 내리는 콘솔 노드</small> |
| [app/B.DeepDiveContainer](app/B.DeepDiveContainer/) | <small>부록 B. 컨테이너 좀 더 깊게 들여다보기</small> | <small>runC로 컨테이너를 만들기 위한 네트워크 구성 스크립트와 설정 파일</small> |
| [app/C.kubespray](app/C.kubespray/) | <small>부록 C. kubespray로 멀티 컨트롤 플레인 구성하기</small> | <small>가상 머신 9대를 만드는 Vagrantfile과 kubespray 실행 준비 스크립트, 타비 설정 파일</small> |
| [docs](docs/) | <small>참고 문서</small> | <small>[쿠버네티스 표준 아키텍처](docs/k8s-stnd-arch/)(연도별), 쿠버네티스 문제 해결 순서도 등 학습에 참고가 될 만한 문서</small> |

### 실습 코드를 다시 내려받으려면

실습하다가 파일을 바꾸거나 지워서 처음 상태로 되돌리고 싶다면 cp-k8s에서 다음 명령을 실행합니다. 깃허브에 저장된 코드와 같은 내용으로 다시 내려받습니다.

```bash
root@cp-k8s:~# rerepo-book-k8sinfra
```

---

## 🔔 베이그런트 설치로 너무 고생하시는 분들을 위한 이미지(OVA) 파일

현재 책의 쿠버네티스 실습 랩을 Vagrant가 아닌 이미지로 바로 구성할 수 있도록 OVA 이미지를 제공합니다.

> 자세한 설정법에 관련한 영상은 아래에 [유용한 정보](#유용한-정보) 부분을 참고하시기 바랍니다.

OVA 파일은 [OneDrive 공유 폴더](https://1drv.ms/f/c/d5b3e33f85008b00/IgAAiwCFP-OzIIDVeQMAAAAAAelbvEalYNHz86k2n7qOrIc?e=lRsHXE)에서 내려받을 수 있습니다. 실습 환경마다 가상 머신 4대(cp-k8s, w1-k8s, w2-k8s, w3-k8s)의 OVA 파일이 1개씩 있습니다.

| 실습 환경 | 애플 실리콘 맥(arm64) | 윈도, 인텔 맥(x86) |
|-----------|----------------------|--------------------|
| 3~6장(`ch3/3.1.3`, 쿠버네티스 1.36.0) | `3.1.3/arm64` 폴더 | `3.1.3/x86` 폴더 |
| 7장(`ch7/7.1.1`, 쿠버네티스 1.36.1) | `7.1.1/arm64` 폴더 | `7.1.1/x86` 폴더 |

다음 순서로 가져옵니다. 맥(애플 실리콘, 인텔)과 윈도에서 확인했습니다.

1. (맥만 해당) 베이그런트로 실습 환경을 만든 적이 없다면 가상 머신끼리 통신할 호스트 전용 네트워크를 먼저 만듭니다. `vagrant up`을 한 번이라도 실행했다면 이 네트워크가 이미 있으므로 건너뜁니다.
   ```bash
   VBoxManage hostonlynet add --name vagrantnet-vbox1 --netmask 255.255.255.0 --lower-ip 192.168.1.0 --upper-ip 192.168.1.0 --enable
   ```
2. 버추얼박스의 **파일 > 가상 시스템 가져오기**로 OVA 파일 4개를 하나씩 가져옵니다. 설정은 기본값 그대로 둡니다.
3. 가상 머신 4대를 시작하고 1~2분 정도 기다린 뒤 타비로 cp-k8s(127.0.0.1:60010)에 접속해 `kubectl get nodes`로 노드 4대가 모두 Ready인지 확인합니다.

OVA에 들어 있는 쿠버네티스 인증서는 2036년 11월까지 사용할 수 있도록 늘려 두었습니다. 파일이 온전히 내려받아졌는지는 각 폴더의 `SHA256SUMS`로 확인할 수 있습니다.

## 유용한 정보

- 🎬 [Mac 및 Windows 사용자를 위한 터미널 프로그램인 타비(Tabby) 추천 및 설정법](https://youtu.be/4MhZxSS3Xm8)
- 🎬 [`vagrant up` 실행 시에 발생하는 에러와 해결책 사례](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%89%BD%EA%B2%8C%EC%8B%9C%EC%9E%91/lecture/72911?inst=cf657a9d)
- 🎬 [테인트(Taints)와 톨러레이션(Tolerations) 설명 영상](https://www.inflearn.com/course/%EA%B7%B8%EB%A6%BC%EC%9C%BC%EB%A1%9C-%EB%B0%B0%EC%9A%B0%EB%8A%94-%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4/lecture/85683?inst=f3d96ed5)
- 🎬 [쿠버네티스 실습 랩을 vagrant가 아닌 이미지로 바로 구성 설치하는 법](https://youtu.be/KxhSWf0ObEU)
- 📜 [깃옵스(GitOps)를 여행하려는 입문자를 위한 안내서](https://yozm.wishket.com/magazine/detail/2010/) (5.5절)
- 📜 [비용&보안 두 마리 토끼 잡는 디스트로리스 이미지 이용법](https://yozm.wishket.com/magazine/detail/2527/) (4.4.3절)

## 문의

- 책대로 실습했는데 진행되지 않거나 책의 설명, 코드가 저장소와 다르다면 [이슈](../../issues/new/choose)로 알려 주세요.
- 일반 질문은 [쿠버네티스 오픈 채팅](https://open.kakao.com/o/gxSooElb)(암호: kubectl)에서, 오탈자는 [길벗](https://www.gilbut.co.kr) 고객센터의 1:1 문의로 알려 주세요.

## 📌 정오표 (오류 수정 및 추가 정보 제공)

본 도서의 쇄별 정정 사항은 [Releases](../../releases)에서 확인하실 수 있습니다.

## 저자

- ✔️ 조훈: [GitHub](https://github.com/sysnet4admin), [LinkedIn](https://www.linkedin.com/in/hoonjo/), [YouTube](https://www.youtube.com/@kuberneteslab), [kuberneteslab.dev](https://kuberneteslab.dev/)
- ✔️ 심근우: [GitHub](https://github.com/gnu-gnu), [LinkedIn](https://www.linkedin.com/in/gnu-shim/)
- ✔️ 문성주: [GitHub](https://github.com/seongjumoon), [LinkedIn](https://www.linkedin.com/in/seongjuishere/)
- ✔️ 이성민: [GitHub](https://github.com/sungmincs), [LinkedIn](https://www.linkedin.com/in/sungmincs/)

## 도서 구입 안내

본 도서는 각 온오프라인 서점에서 만나보실 수 있습니다. (ISBN 979-11-407-2135-1)

- 📍 [교보문고](https://product.kyobobook.co.kr/detail/S000221973541)
- 📍 [예스24](https://www.yes24.com/product/goods/201050615)
- 📍 [알라딘](https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=407128509)

***
<p align="center">
<a href="https://promo.kuberneteslab.dev/ko/">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://promo.kuberneteslab.dev/images/readme/banner-ko-dark.png">
  <img src="https://promo.kuberneteslab.dev/images/readme/banner-ko-light.png" alt="리눅스 재단 자격증 할인 코드: CKA, CKS, MCPA 등 상시 30% 코드 KUBELAB30, 더 큰 할인은 눌러서 확인" width="720">
</picture>
</a>
</p>
