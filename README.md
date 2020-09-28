# TOAST k8s.oss-helm-packages

> 오픈소스를 이용한 토스트 쿠버네티스 활용 가이드

[![github release version](https://img.shields.io/github/v/release/nhn/tui.editor.svg?include_prereleases)](https://github.com/nhn/tui.editor/releases/latest)[![license](https://img.shields.io/github/license/nhn/tui.editor.svg)](https://github.com/nhn/tui.editor/blob/master/LICENSE)[![code with hearth by NHN](https://img.shields.io/badge/%3C%2F%3E%20with%20%E2%99%A5%20by-NHN-ff1414.svg)](https://github.com/nhn)

## 🚩 Table of Contents

- [OSS HELM PACKAGES](#-packages)
- [StorageClass](#-why-toast-ui-editor)
- [Argocd](#-features)
- [Gitlab](#-examples)
- [Grafana](#-browser-support)
- [Loki](#-pull-request-steps)
- [Prometheus](#-contributing)
- [TOAST UI Family](#-toast-ui-family)
- [Used By](#-used-by)
- [License](#-license)

#### 토스트 쿠버네티스에서는 다음과 같은 오픈소스 스택을 활용하여 MSA 기반의 어플리케이션, CI/CD DevOps그리고 클러스터 모니터링 환경을 쉽게 구축 할 수 있습니다. 

<img src="https://api-storage.cloud.toast.com/v1/AUTH_1d1d69bb458e4b73b57f25ad339f5067/k8s-guide/screen1.png" alt="oss" width="1000" />

</br>

## 📦 OSS HELM Packages

### TOAST UI Editor

| Name | Description |
| --- | --- |
| StorageClass | Toast Cinder Block Storage for PVC |
| Argocd | Automatic Continuous Deployment Tool for Gitops |
| Gitlab | Private Git Repository |
| Grafana | Dashboard tool for processing and monitoring |
| Loki | Processing log data pulling mechanism tool  |
| Prometheus | http endpoint request pulling metrics mechanism tool |

</br>

## 🤖 StorageClass?

Storage Class는 Toast에서 제공하는 Block Storage(PV)와 Kubernetes에서 마운트할 볼륨(PVC)을 쉽게 자동 매핑해주는 리소스입니다.

Toast Kubernetes의 PersistentVolume 사용을 위한 Storage Class를 생성합니다. 

``` sh
$ kubectl apply -f storageClass
```



## 🎨  Argocd?

Kubernetes Devops를 구축하기 위해 Gitlab(Continuous Integration)와 Argocd(continuous Deployment)를 사용합니다.

Argocd는 컨테이너 네이티브 오픈소스 엔진으로 선언적 방식의 새로운 어플리케이션을 클러스터에 쉽게 구축 및 배포하는 Tool입니다. 

<img src="https://api-storage.cloud.toast.com/v1/AUTH_1d1d69bb458e4b73b57f25ad339f5067/k8s-guide/screen2.png" alt="argocd" width="1000" />

``` sh
$ kubectl create namespace argocd

$ helm install argocd ./argocd -n argocd

$ kubectl get svc argocd-server -n argocd -o=jsonpath='{$.status.loadBalancer.ingress[0].ip}';echo
```


## 💪  Gitlab?

Gitlab은 깃 원격 저장소 기능, 이슈 트래커, 그리고 CI/CD 기능 등을 제공하는 버전 관리 소프트웨어입니다. 


<img src="https://api-storage.cloud.toast.com/v1/AUTH_1d1d69bb458e4b73b57f25ad339f5067/k8s-guide/gitlab-docker-ansible.png" alt="gitlab" width="1000" />

``` sh
$ kubectl create namespace gitlab

$ helm install gitlab ./gitlab -n gitlab

$ helm install argocd ./argocd -n argocd

$ kubectl  get svc -n gitlab -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}'; echo

$ kubectl set env deployment/gitlab-deployment -n gitlab GITLAB_OMNIBUS_CONFIG="external_url 'http://$(kubectl get svc -n gitlab -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')/'"

$ kubectl  get svc -n gitlab -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}'; echo
```



## ⭐️  Grafana?

Grafana는 open source visualization and anlytics software로 dashboard를 통해 프로세싱 된 로그, 메트릭스 정보등의 지표들을 보여줍니다.


<img src="https://api-storage.cloud.toast.com/v1/AUTH_1d1d69bb458e4b73b57f25ad339f5067/k8s-guide/screen5.png" alt="grafana" width="1000" />

``` sh
$ kubectl create namespace monitoring

$ helm install grafana ./grafana -n monitoring

$ kubectl get svc --namespace monitoring grafana -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

## 🔥  Loki?

Grafana Loki는 pulling 방식의 모니터링 오픈소스인 Prometheus에 영감을 받아 개발된 로그 시스템입니다.

Loki의 특징은 다음과 같습니다.
* **Chunk Indexing** : full text 인덱싱 방식이 아닌 metadata 정보 (labels)와 로그를 압축 저장 후 chunk파일을 생성하여 인덱싱 합니다.
* **Label Tracking** : label를 통해 application 컨테이너의 정보, 시간, 날짜, 로그타입을 선별하여 손쉽게 로그를 조회 할 수 있습니다.
* **Container Deployment** : Kubernetes Dynamic 환경에 최적화 되어 있습니다.


<img src="https://api-storage.cloud.toast.com/v1/AUTH_1d1d69bb458e4b73b57f25ad339f5067/k8s-guide/screen6.png" alt="Loki" width="1000" />

Loki log agent인 Promtail과 Loki 설치를 진행합니다.

``` sh
$ helm install promtail ./promtail -n monitoring

$ helm install loki ./loki -n monitoring

* Grafana 접속
$ kubectl get svc --namespace monitoring grafana -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

#### Loki를 통해 축적되는 로그는 Grafana를 통해 볼수 있습니다.

## ☄️ Prometheus

Prometheus 는 Kubernetes에서 가장 많이 사용하는 오픈 소스 기반 모니터링 시스템으로(pull-based over http monitoring), http endpoint를 통해 원하는 타켓의 Kubernetes 클러스터 및 Docker 컨테이너들를 손쉽게 모니터링 가능합니다.

Prometheus의 특징은 다음과 같습니다.
* **Api Communication** : Prometheus는 http endpoints를 통해 원하는 서버의 metrics 정보를 가져옵니다.
* **Time Seriese Sampling** : 한대의 Prometheus 서버는 수개의 million time series (시간 구간)에 준하는 초당 1 million의 샘플을 처리할 수 있습니다.
* **Query Language** : Metircs 검색에 유연한 쿼리 언어인 PromQL을 지원합니다.



<img src="https://api-storage.cloud.toast.com/v1/AUTH_1d1d69bb458e4b73b57f25ad339f5067/k8s-guide/screen8.png" alt="Prometheus" width="1000" />

Loki log agent인 Promtail과 Loki 설치를 진행합니다.

``` sh
$ helm install prometheus ./prometheus -n monitoring

```

#### Prometheus를 통해 축적되는 로그는 Grafana를 통해 볼수 있습니다.



## 🎨 Features

* [**Viewer**](https://github.com/nhn/tui.editor/tree/master/apps/editor/docs/viewer.md) : Supports a mode to display only markdown data without an editing area.
* [**Internationalization (i18n)**](https://github.com/nhn/tui.editor/tree/master/apps/editor/docs/i18n.md) : Supports English, Dutch, Korean, Japanese, Chinese, Spanish, German, Russian, French, Ukrainian, Turkish, Finnish, Czech, Arabic, Polish, Galician, Swedish, Italian, Norwegian, Croatian + language and you can extend.

## 🐾 Examples

* [Basic](https://nhn.github.io/tui.editor/latest/tutorial-example01-editor-basic)
* [Viewer](https://nhn.github.io/tui.editor/latest/tutorial-example04-viewer)
* [Using All Plugins](https://nhn.github.io/tui.editor/latest/tutorial-example15-editor-with-all-plugins)
* [Creating the User's Plugin](https://nhn.github.io/tui.editor/latest/tutorial-example17-creating-plugin)
* [Customizing the Toobar Buttons](https://nhn.github.io/tui.editor/latest/tutorial-example19-customizing-toolbar-buttons)
* [Internationalization (i18n)](https://nhn.github.io/tui.editor/latest/tutorial-example20-i18n)

Here are more [examples](https://nhn.github.io/tui.editor/latest/tutorial-example01-editor-basic) and play with TOAST UI Editor!


## ☀️ Kubernetes Support

| K8S 1.17 ~ | Helm 3.0 ~

| Yes |  Yes |


## 💬 Contributing

* [Code of Conduct](https://github.com/nhn/tui.editor/blob/master/CODE_OF_CONDUCT.md)
* [Contributing Guideline](https://github.com/nhn/tui.editor/blob/master/CONTRIBUTING.md)
* [Commit Convention](https://github.com/nhn/tui.editor/blob/master/docs/COMMIT_MESSAGE_CONVENTION.md)
* [Issue Guidelines](https://github.com/nhn/tui.editor/tree/master/.github/ISSUE_TEMPLATE)


## 🚀 Used By

* [TOAST Cloud! - Toast Kubernetes, Toast Container Registry](https://toast.com)
* [UNOTES - Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ryanmcalister.Unotes)


## 📜 License

This software is licensed under the [MIT](https://github.com/nhn/tui.editor/blob/master/LICENSE) © [NHN](https://github.com/nhn).