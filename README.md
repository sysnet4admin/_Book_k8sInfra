# 컨테이너 인프라 환경 구축을 위한 쿠버네티스/도커
이 저장소는 [컨테이너 인프라 환경 구축을 위한 쿠버네티스/도커](https://www.gilbut.co.kr/book/view?bookcode=TBD) 책에 실습을 위한 코드를 제공합니다.

각 챕터별로 챕터에서 사용하는 스크립트 및 코드를 제공하고 있으며, 별도로 챕터에서 깊게 다루지 않는 부분은 [다른 저장소](https://github.com/iac-source)에서 다룹니다.

이 저장소에서 다루는 챕터에 따라 제공되는 스크립트는 아래와 같습니다.

***

## 제공되는 스크립트
<table>
    <thead>
        <tr>
            <th>경로</th>
            <th>챕터 이름</th>
            <th>사용 목적 및 제공 스크립트</th>
        </tr>
    </thead>
    <tbody>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch2">ch2</a></td>
        <td>테스트 환경 구성하기</td>
        <td>가상환경 배포의 이해를 돕기 위한 Vagrantfile과 프로비저닝 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch3">ch3</a></td>
        <td>쿠버네티스로 알아보는 현대적인 인프라 환경</td>
        <td><a href="https://kubernetes.io">쿠버네티스</a>의 다양한 오브젝트를 구성하기 위한 야믈 파일과 쿠버네티스를 실습하기 위한 가상환경 배포 파일, 동작 테스트를 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch4">ch4</a></td>
        <td>쿠버네티스를 이루는 컨테이너 도우미, 도커</td>
        <td><a href="https://docker.com">도커</a>의 일반적인 사용 방법, 도커 고급 기능을 사용하기 위한 가상환경 배포 파일 및 사설 도커 레지스트리를 구성하기 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch5">ch5</a></td>
        <td>지속적인 통합과 배포 자동화, 젠킨스</td>
        <td><a href="https://helm.sh">헬름</a>으로 쿠버네티스 환경에 젠킨스를 배포하기 위한 및 젠킨스를 이용한 CI/CD에 관련된 스크립트 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch6">ch6</a></td>
        <td>안정적인 운영을 완성하는 모니터링, 프로메테우스와 그라파나</td>
        <td><a href="https://helm.sh">헬름</a>으로 쿠버네티스 환경에 프로메테우스와 그라파나를 배포하기 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td rowspan="4"><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/app">app</a></td>
        <td>A. Kubectl을 더 쉽게 사용하기</td>
        <td>kubectl을 쉽게 사용할 수 있도록 구성된 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td>B. Kubespray로 쿠버네티스 자동 구성하기</td>
        <td>kubespray를 통해 쿠버네티스 클러스터 구축에 필요한 스크립트를 제공합니다..</td>
    </tr>
    <tr>
        <td>C. 쿠버 대시보드 구성하기</td>
        <td>쿠버네티스 대시보드를 배포하기 위한 야믈파일을 제공합니다.</td>
    </tr>
    <tr>
        <td>D. 컨테이너 깊게 들여다보기</td>
        <td>컨테이너를 깊게 들여다보기 위한 스크립트들을 제공합니다.</td>
    </tr>
   </tbody>
</table>

***

## 저자
- [조 훈](https://github.com/sysnet4admin)
- [심근우](https://github.com/gnu-gnu)
- [문성주](https://github.com/seongjumoon)

## 도서 구입 안내
본 도서는 각 온오프라인 서점에서 만나보실 수 있습니다.
- 📍 [YES24](https://bit.ly/3iq4L5W)
- 📍 [알라딘](https://bit.ly/3cpo37M)
- 📍 [교보문고](https://bit.ly/3g1dsC7)
- 📍 [인터파크(https://bit.ly/3pydepi)
