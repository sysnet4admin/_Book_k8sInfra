# 컨테이너 인프라 환경 구축을 위한 쿠버네티스/도커
<a href="http://www.yes24.com/Product/Goods/102099414">
<img src="http://image.kyobobook.co.kr/images/book/xlarge/743/x9791165215743.jpg" width="400">
</a>

> 🔔 **_알림1:_** VirtualBox 6.1.28 이후 버전에서는 Vagrant host-only network와 관련된 이슈과 맥과 리눅스에서 
> 발생합니다. 자세한 내용은 [다음의 문서](https://github.com/sysnet4admin/_Book_k8sInfra/blob/main/docs/%EC%8B%A4%EC%8A%B5%20%EC%9D%B4%EC%8A%88%231%20-%20VritualBox%20host-only%20Network(MAC%2CLinux).pdf)를 확인하시기 바랍니다.  

> 🔔 **_알림2:_** MetalLB의 [Docker 허브 저장소](https://hub.docker.com/u/metallb)가 더이상 사용되지 않게 됨으로서, quay.io로 변경하였습니다. 
> 이에 MetalLB 관련한 문제가 생기시는 경우 현재 수정된 소스를 다시 내려받으시기 바랍니다. 

> 🔔 **_알림3:_** MetalLB의 [쿠버네티스 인증서](https://kubernetes.io/docs/setup/best-practices/certificates/)의 기본값이 1년인 관계로 OVA의 경우 사용을 못하는 경우가 발생합니다.
> 이에 OVA를 10년으로 변경하였습니다. 그리고 만약 vagrant up으로 배포한 랩의 사용기간이 1년이 다 되어가는 경우 [인증서를 갱신](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)하시기 바랍니다.  

이 저장소는 [컨테이너 인프라 환경 구축을 위한 쿠버네티스/도커](http://www.yes24.com/Product/Goods/102099414) 책에 실습을 위한 코드를 제공합니다.

각 챕터별로 챕터에서 사용하는 스크립트 및 코드를 제공하고 있으며, 별도로 챕터에서 깊게 다루지 않는 부분은 [다른 저장소](https://github.com/iac-source)에서 다룹니다. 그리고 학습에 도움이 되실만한 문서를 디렉터리 [docs](https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/docs)에 추가하였습니다. (2021.10.24)

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
        <td><a href="https://www.vagrantup.com/">베이그런트</a>를 이용해서 가상 테스트 환경을 자동으로 배포하기 위한 Vagrantfile과 프로비저닝 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch3">ch3</a></td>
        <td>쿠버네티스로 알아보는 현대적인 인프라 환경</td>
        <td><a href="https://kubernetes.io">쿠버네티스</a>의 다양한 오브젝트를 구성하기 위한 야믈 파일과 쿠버네티스를 실습하기 위한 가상환경 배포 파일, 동작 테스트를 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch4">ch4</a></td>
        <td>쿠버네티스를 이루는 컨테이너 도우미, 도커</td>
        <td><a href="https://docker.com">도커</a>의 일반적인 사용 방법, 도커 고급 기능을 사용하기 위한 가상환경 배포 파일 및 사설 <a href="https://docs.docker.com/registry/">도커 레지스트리</a>를 구성하기 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch5">ch5</a></td>
        <td>지속적인 통합과 배포 자동화, 젠킨스</td>
        <td><a href="https://helm.sh">헬름</a>으로 쿠버네티스 환경에 <a href="https://www.jenkins.io/">젠킨스</a>를 배포하고, CI/CD를 구현할 수 있는 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/ch6">ch6</a></td>
        <td>안정적인 운영을 완성하는 모니터링, 프로메테우스와 그라파나</td>
        <td><a href="https://helm.sh">헬름</a>으로 쿠버네티스 환경에 <a href="https://prometheus.io/">프로메테우스</a>와 <a href="https://grafana.com/">그라파나</a>를 배포하고 모니터링할 수 있는 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td rowspan="4"><a href="https://github.com/sysnet4admin/_Book_k8sInfra/tree/main/app">app</a></td>
        <td>A. Kubectl을 더 쉽게 사용하기</td>
        <td><a href="https://kubernetes.io/ko/docs/reference/kubectl/overview/">kubectl</a>을 쉽게 사용할 수 있도록 구성된 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td>B. Kubespray로 쿠버네티스 자동 구성하기</td>
        <td><a href="https://github.com/kubernetes-sigs/kubespray">kubespray</a>를 통해 쿠버네티스 클러스터를 자동으로 구축하기 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td>C. 쿠버 대시보드 구성하기</td>
        <td><a href="https://github.com/kubernetes/dashboard">쿠버네티스 대시보드</a>를 배포하기 위한 스크립트를 제공합니다.</td>
    </tr>
    <tr>
        <td>D. 컨테이너 깊게 들여다보기</td>
        <td><a href="https://github.com/opencontainers/runc">컨테이너를 깊게</a> 들여다보기 위한 스크립트를 제공합니다.</td>
    </tr>
   </tbody>
</table>

***

## 저자
- ✔️   [조 훈](https://github.com/sysnet4admin)
- ✔️   [심근우](https://github.com/gnu-gnu)
- ✔️   [문성주](https://github.com/seongjumoon)

## 도서 구입 안내
본 도서는 각 온오프라인 서점에서 만나보실 수 있습니다.
- 📍  [YES24](https://bit.ly/3iq4L5W)
- 📍  [알라딘](https://bit.ly/3cpo37M)
- 📍  [교보문고](https://bit.ly/3g1dsC7)

## 책에서 사용하는 프로그램 번들팩
`VirtualBox 6.1.12`, `vagrant 2.2.9` 
- 🗄️  [윈도우 사용자](https://1drv.ms/u/s!Auu_3Z_BinL5enOZ9GNLpYpW9GI?e=Bm81j6)
- 🗄️  [맥OS 사용자](https://1drv.ms/u/s!Auu_3Z_BinL5eYkQshnmOaaprJA?e=Z7WJwb)

## 🔔 베이그런트 설치로 너무 고생하시는 분들을 위한 이미지(OVA) 파일
현재 책의 쿠버네티스 실습 랩을 Vagrant가 아닌 이미지로 바로 구성할 수 있도록 OVA 이미지를 제공합니다. </br>
다음의 두가지 이미지 번들 팩을 제공합니다. 
 - [3.1.3](https://1drv.ms/u/s!Auu_3Z_BinL5dxYJfjk7c25L58Y?e=A6ql5d)에 해당 하는 이미지
 - [4.3.4](https://1drv.ms/u/s!Auu_3Z_BinL5eJrtyjnc1mW5oa8?e=5pVpmc)에 해당하는 이미지 </br>
> 자세한 설정법에 관련한 영상은 아래에 [유용한 정보](#유용한-정보) 부분을 참고하시기 바랍니다.   

## 유용한 정보
-  📑  [Mac 및 Windows 사용자를 위한 터미널 프로그램인 타비(Tabby) 추천 및 설정법](https://youtu.be/4MhZxSS3Xm8)
-  🎬  [`vagrant up` 실행 시에 발생하는 에러와 해결책 사례](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%89%BD%EA%B2%8C%EC%8B%9C%EC%9E%91/lecture/72911?inst=cf657a9d)
-  🎬  [테인트(Taints)와 톨러레이션(Tolerations) 설명 영상](https://www.inflearn.com/course/%EA%B7%B8%EB%A6%BC%EC%9C%BC%EB%A1%9C-%EB%B0%B0%EC%9A%B0%EB%8A%94-%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4/lecture/85683?inst=f3d96ed5)
-  🎬  [멀티 컨텍스트 랩 환경 구성 on Ubuntu 설명 영상(10:15~)](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%89%BD%EA%B2%8C%EC%8B%9C%EC%9E%91/lecture/73341?inst=cf657a9d)
-  🎬  [쿠버네티스 v1.24에서 발생할 컨테이너 런타임의 변경에 관해서 (dockershim vs containerd)](https://www.inflearn.com/course/%EA%B7%B8%EB%A6%BC%EC%9C%BC%EB%A1%9C-%EB%B0%B0%EC%9A%B0%EB%8A%94-%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4/lecture/106937?inst=f3d96ed5)
-  🎬  [쿠버네티스 실습 랩을 vagrant가 아닌 이미지로 바로 구성 설치하는 법](https://youtu.be/KxhSWf0ObEU)
-  🎬  [슈퍼푸티 터미널을 생산성 있게 꾸미기](https://youtu.be/kv87ynbJlmk)

## 관련 문서 
-  📜 [왜 쿠버네티스는 systemd로 cgroup을 관리하려고 할까요?](https://www.slideshare.net/JoHoon1/systemd-cgroup)
