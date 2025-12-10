# 2026 Kubernetes Standard Architecture

[한국어 버전 보기](README.md)

## Background for Standard Architecture Selection

By 2026, Kubernetes has become the unrivaled platform for container orchestration. However, 2026 has brought significant changes, particularly the **aggressive adoption of OCI** and the **planned end-of-support for Ingress NGINX**. For more details, please refer to the sections on Helm, Harbor, and Ingress. <br>
Kubernetes doesn't exist as a standalone product; it operates by organically connecting various containerized applications running on it for different purposes. Therefore, mature projects are crucial elements. As of October 28, 2025, the Cloud Native Computing Foundation (CNCF) has announced a total of 34 graduated projects.

![2025 cncf-graduated-by-timeline](img/2025Oct28-graduated.cncf.io.png)
[Figure 1] **CNCF Graduated Projects by Timeline (as of October 28, 2025)**

Beyond graduated projects, understanding and selecting many products is necessary to use Kubernetes for various purposes.<br> <br>
![2025 cncf landscape](img/2025Dec10-landscape.cncf.io.png)
[Figure 2] **Products Provided by CNCF (as of December 10, 2025)**

<br>Even if you use managed Kubernetes services (EKS, AKS, GKE), many of the above products may already be integrated into your managed Kubernetes. <br>
Even if not integrated, open-source versions are often directly applied to managed Kubernetes environments, so understanding and using them will help you better understand managed Kubernetes. <br>
The important point here is that if you already have a well-functioning configuration and products, **the currently configured products are the optimal configuration for your business**. For this reason, although titled "**Standard**," it should be noted that it's actually closer to market trends rather than an absolute standard. <br>
Finally, to achieve the goal of operating Kubernetes stably and conveniently, we have actively adopted various products beyond open source. <br>
<br>
For these reasons, please understand that the following selected products serve as a guide for those starting with Kubernetes or as a reference when considering new configurations. <br>
Some are already de facto standards, but some products have been selected to fit the Korean market. For example, Helm, Argo CD, Harbor, Prometheus, and Grafana are at a level where no deliberation is needed, while others may vary depending on business characteristics.
If you're considering how to compose Kubernetes in 2026 and which direction to take, the [current configuration](2026-k8s-stnd-arch.pdf) will be very helpful. <br>

![2025 k8s thumbnail](img/2026-k8s-stnd-arch-thumbnail.png)<br>
[Figure 3] **2026 Kubernetes Standard Configuration** ([pdf original](2026-k8s-stnd-arch.pdf))

We hope this makes your entry into or activation of Kubernetes easier this year.

[Hoon Jo](https://github.com/sysnet4admin), [Geunwoo Shim](https://github.com/gnu-gnu), [Seongjoo Moon](https://github.com/seongjumoon), [Sungmin Lee](https://github.com/sungmincs)

### Why AI-Related Projects Besides KubeFlow Are Not Included
AI workloads such as DRA, vLLM, Ray, llm-d, Kueue, and kagent are developing very rapidly, making it difficult to organize them with a single direction. <br>
However, the important thing is that CNCF's influence in the open-source ecosystem is very strong, so Kubernetes infrastructure is most likely to be used for AI workloads, especially in the inference domain.
In the training domain, Kubernetes is also partially replacing Slurm, which has been widely used. <br>
As the current state is very volatile, we haven't organized it as a standard. However, there's a high possibility that vLLM will be used close to the standard for serving LLMs in 2026. vLLM is a tool for high-performance LLM inference serving, providing high throughput and efficient memory usage through optimization techniques like PagedAttention. By the end of 2026, the AI workload ecosystem is expected to mature further, with standardized patterns becoming clearer in both inference and training domains, which we plan to reflect in the 2027 standard architecture.


---
🗑 Deleted 🗑
### Kubernetes Integrated Development Environment (IDE) Tools
**[Lens](https://github.com/lensapp/lens), GitHub Stars: 23k, License: See documentation <br>**
The most widely used GUI tool for managing Kubernetes. Lens allows easy management of various Kubernetes resources and can also manage Helm charts. You can register and view multiple clusters in Lens, which is very convenient. It can integrate with Prometheus for simple monitoring and has convenience features like opening shells in pods (Attach) or port forwarding from the menu. While OpenLens, an open-source project, could be used for free using Lens source code, Lens stopped open-sourcing code in February 2024, ending the OpenLens project. Lens can be used for free by companies with annual revenue under $10 million, requiring caution. Due to these license constraints, we changed to Headlamp, which is completely open source.

**[Jaeger](https://github.com/jaegertracing/jaeger), GitHub Stars: 22.1k, License: Apache License 2.0 <br>**
Jaeger is a trace tool that collects events occurring in distributed microservices. It's mainly used to find bottlenecks in distributed applications or explore errors occurring between distributed applications. To track application issues, separate SDK addition and span addition work in the scope to be explored are required. Trace data generation and collection use OpenTelemetry SDK and Collector in a standardized OTLP (OpenTelemetry Protocol) manner, so backend tools for storing trace data can be freely chosen according to organizational environment and requirements. Therefore, while Tempo is emerging as a newer alternative, if you already use Jaeger or Zipkin as trace tools, they can still be used as they can receive OTLP. This is because OpenTelemetry standardizes instrumentation, providing flexibility to use any backend without code changes. However, traditional Jaeger relied on indexing all span tags and metadata for data retrieval, which increased storage space and computing resource costs for index maintenance as data volume grew. For this reason, we changed to Tempo, which processes trace data storage more efficiently by minimizing indexes compared to Jaeger. The advantage of tight visualization integration with Grafana, enabling close linking of metrics, logs, and traces, was also considered.

**[Kibana](https://github.com/elastic/kibana): Log and data visualization dashboard, GitHub Stars: 20.8k, License: AGPL 3.0/SSPL/Elastic License 2.0 <br>**
Kibana provides useful dedicated dashboard functionality for visualizing and exploring Elasticsearch (or OpenSearch) data. Log data can already be viewed in Elasticsearch and OpenSearch through Grafana's data source plugin. Therefore, to avoid the complexity of maintaining and managing a separate dedicated visualization stack like Kibana (or OpenSearch Dashboards), and to provide operational simplification and integrated monitoring experience, we exclude Kibana and unify on Grafana-based visualization. However, if very complex and detailed text-based search and analysis is needed in the future, adding Kibana or OpenSearch Dashboards can be considered.

**[Elasticsearch](https://github.com/elastic/elasticsearch): Log storage and search engine, GitHub Stars: 75.6k, License: AGPL 3.0/SSPL/Elastic License 2.0 <br>**
Elasticsearch provides powerful text search capabilities based on Apache Lucene, very useful for storing and later searching logs and events. Main reasons for excluding Elasticsearch from the log pipeline and switching to other tools include increased operational complexity and cost efficiency. To visualize and explore Elasticsearch data, a separate dedicated dashboard tool, Kibana, must be configured and managed together. However, OpenSearch, an alternative that emerged after Elasticsearch's license change, has the advantage of being able to use features equivalent to Kibana's enterprise subscription—single sign-on, user and role-based access control, and data exploration—in the open-source version through OpenSearch Dashboards directly integrated with OpenSearch. Elasticsearch's license change caused community ecosystem separation from OpenSearch, making community-based problem solving relatively difficult when choosing Elasticsearch as primary. To solve these operational complexities and license issues while improving cost efficiency, we switched to using OpenSearch for log storage and visualization. If you can receive enterprise technical support or are already operating Elasticsearch in your existing environment, using Elasticsearch is fine.

---

## Component Descriptions

### Cluster Access Control
**[Teleport](https://github.com/gravitational/teleport), GitHub Stars: 19.4k, License: GNU AGPL v3.0 <br>**
Teleport is a tool that helps secure access to various infrastructure environments (servers, databases, Kubernetes, etc.). One of the biggest reasons access control tools like Teleport are important is that incorrect operations on Kubernetes resources can cause service-wide issues in worst cases. To prevent this, you must control what and how actual workers can proceed, and record this for later problem identification. While Kubernetes RBAC can implement this to a limited extent, managing everything individually is not easy.
However, using tools like Teleport makes all previously explained content easily implementable, with the advantage of easily integrating authentication and authorization with Keycloak. Another advantage of using Teleport is that all worker activities are recorded and stored, usable as audit records later and helping prevent future problems by post-mortem analysis.
Especially as organizational scale and complexity increase, the need for such tools increases even more.

### Cluster Authentication and Authorization
**[Keycloak](https://github.com/keycloak/keycloak), GitHub Stars: 31.3k, License: Apache License 2.0 <br>**
Keycloak is an IAM (Identity and Access Management) tool that is an open-source tool allowing Single Sign-On (SSO). Kubernetes APIs or applications deployed in internet-accessible locations can be accessed by anyone, so using Keycloak allows managing access after authentication using specific IdPs (Identity Providers) like Google. You can also easily manage cluster-wide access permissions, such as setting each user's permissions in stages using LDAP (Lightweight Directory Access Protocol).


### API Server Load Balancer
**[HAPROXY](https://github.com/haproxy/haproxy), GitHub Stars: 6.1k, License: [See link](https://github.com/haproxy/haproxy/blob/master/LICENSE) <br>**
HAProxy had high market share as an open-source load balancer even before using Kubernetes. It's used for load balancing to multiple Kubernetes API servers deployed on control plane nodes. Health check support helps resolve single point of failure issues.


### Network Implementation

#### Container Network Interface (CNI)
**[Calico](https://github.com/projectcalico/calico), GitHub Stars: 6.9k, License: Apache License 2.0 <br>**
Among CNIs, it's the easiest and fastest to apply, with a thick user base. It particularly supports the most popular BGP protocol in current data centers well and has performance positioned at the top. Recently, another CNI, Cilium, applies eBPF and XDP to secure network traffic visibility while improving network routing performance. However, added features make network structure difficult to trace, and validated host OS kernel version changes are currently required. Therefore, if system changes are difficult or you prefer proven configurations, choosing Calico is good. Of course, Calico also supports eBPF and XDP.


**[Cilium](https://github.com/cilium/cilium), GitHub Stars: 22.9k, License: Apache License 2.0 <br>**
One of the CNI types, simple to install but difficult to configure options needed for specific features. However, through latest kernel features like eBPF and XDP, replacing kube-proxy (iptables, ipvs) improves network forwarding performance between Kubernetes clusters and has the advantage of observing network traffic.
Calico also recently improved network forwarding performance using eBPF and XDP.
Additionally, Cilium's self-provided L2 load balancer and service mesh between different Kubernetes clusters allow applying Cilium if there's demand for these features.


#### L4/L7 Network Implementation
**[MetalLB](https://github.com/metallb/metallb): Kubernetes load balancer, GitHub Stars: 7.9k, License: Apache License 2.0 <br>**
A product that supports using load balancer services in Kubernetes. One of the oldest and most mature products, supporting both L2 and L3 (BGP) modes. From v0.13.2, IP pools, modes, etc., can be conveniently set in CRD format.

(❗ **Warning** ❗)
**[Nginx Ingress Controller](https://github.com/kubernetes/ingress-nginx): Kubernetes Ingress, GitHub Stars: 19.2k, License: Apache License 2.0 <br>**
Ingress is an object that exposes URL paths from outside the cluster to inside via HTTP and HTTPS. There are various implementations of ingress controllers managing ingress, with Nginx-based ingress controllers being most widely used. However, official support ends in November 2025, with security updates and bug fixes ceasing after March 2026. Gateway API, which adds more features to ingress and more structurally configures object relationships, became GA in October 2023 and is recommended as Nginx Ingress Controller's successor. Therefore, production environments should prepare migration to Gateway API or other ingress controllers. Current Gateway API has major candidates including Nginx Fabric, Envoy, Istio, Cilium, kgateway, Kong, Traefik, and the situation is very competitive, making it impossible to determine a specific Gateway API. Therefore, this will be reflected in 2027. As of December 2025, please refer to the following link for Gateway API PoC and the following link for BMT.


**[k8gb](https://github.com/k8gb-io/k8gb): Kubernetes Global Load Balancer, GitHub Stars: 1.1k, License: Apache License 2.0 <br>**
Kubernetes Global Load Balancer is designed with reference to GSLB (Global Server Load Balancing), aiming to implement receiving similar network traffic as much as possible regardless of which Kubernetes region you're in. Therefore, it's a product that helps configure global networks for hybrid cloud in multi-cluster environments composed of CSP (Cloud Service Provider, AWS/Azure/GCP).


### Usability Simplification Tools

**[Helm](https://github.com/helm/helm): Deployment simplification tool, GitHub Stars: 29.1k, License: Apache License 2.0 <br>**
As a Kubernetes package manager, it's a tool that helps easily deploy container applications to Kubernetes clusters through Charts. There's also the advantage of customizing applications with desired options through various parameters defined in values.
Especially with the release of Helm version 4 in November 2025, Server-Side Apply based deployment and improved resource monitoring capabilities were introduced, greatly enhancing resource management stability and operational convenience. Additionally, departing from the previous method where charts could only be used after adding repositories with helm repo add, full support for OCI-based chart deployment allows directly fetching needed charts from OCI registries. This greatly improves usability by enabling immediate chart use without separate repository registration. However, as OCI-based chart storage doesn't inherently provide metadata, OCI chart search via helm search command is possible on ArtifactHub; otherwise, the container registry's own search functionality must be used.

(🔁 **Changed** 🔁)
**[Headlamp](https://github.com/kubernetes-sigs/headlamp): Kubernetes Web UI tool, GitHub Stars: 5k, License: Apache License 2.0 <br>**
Headlamp is an easy-to-use and extensible Kubernetes web UI officially included in Kubernetes SIG-UI. It became an official Kubernetes SIG-UI project in 2025, integrating more closely with the Kubernetes community. You can easily manage various Kubernetes resources through Headlamp and extend functionality through the plugin system. You can also register and view multiple clusters conveniently, and in 2025, an AI assistant feature was added, enabling cluster management through natural language interface. It supports both desktop applications and in-cluster deployment, with various plugin ecosystems including Minikube and Karpenter. It's completely open source and can be used for free under the Apache 2.0 license.


### Service Mesh
**[Istio](https://github.com/istio/istio), GitHub Stars: 37.7k, License: Apache License 2.0 <br>**
Istio is a service mesh tool providing features like traffic management and observability. It can be easily installed via istioctl, with the advantage of also being installable via CRD. Ingress traffic can be handled through VirtualService and Gateway, with traffic control possible using filters in between. Additionally, ServiceEntry enables easy dynamic management of cluster internal/external endpoints.
Beyond Istio's main features, service traffic flow can be viewed on web UI through the Kiali dashboard, and service mesh configuration is possible using Envoy proxy. If CPU or memory resources used through the Envoy sidecar pattern are burdensome, you can also configure service mesh using Istio Ambient Mesh, which became GA in 2024, reducing CPU and memory through a daemon called ztunnel (zero trust tunnel) on nodes rather than a sidecar pattern attached to pods.


### Container Management Tools
**[Docker](https://github.com/moby/moby), GitHub Stars: 71.2k, License: Apache License 2.0 <br>**
A synonym for container management tools used for a long time, still used by the most users. Although Kubernetes discontinued Dockershim integration, it can still be used as a tool for container builds. While there were concerns about root permission issues and inconvenience from the daemon-based structure, Redhat's Podman was mentioned as an alternative maintaining Docker compatibility while avoiding root permission use and being daemon-less. However, since Docker version v23.0 adopted buildkit by default, greatly improving build speed and cache usage efficiency, Docker continues to maintain its position as the standard for container build tools.


### Continuous Integration/Deployment (CI/CD) Tools

#### CI/CD
**[Github Actions](https://github.com/actions/runner), GitHub Stars: 5.7k, License: MIT**
Github Actions is a CI/CD tool provided by Github, the world's most famous source code repository. You can configure workflows that can directly build/deploy source stored in Github repositories, offering high utility. You can easily and concisely configure pipelines using numerous open-source templates as well as Github-provided workflow templates. Public repositories can use Github-provided runners for free, while private repositories can be used for free up to 2,000 minutes per month.

**[Jenkins](https://github.com/jenkinsci/jenkins), GitHub Stars: 24.7k, License: MIT <br>**
Jenkins is the most widely used open source in continuous integration and deployment stages. Various plugins provided by the vast community enable integration with almost all languages and tools. Charts for Jenkins installation and Kubernetes plugins usable in Jenkins are provided, making it easy to use on Kubernetes. Using Jenkins Pipeline allows managing scripts used in CI/CD as code in the form of Jenkinsfile in project repositories, making it easy to manage the entire build and deployment process as part of code deployment.

**[Gitlab](https://github.com/gitlabhq/gitlabhq), GitHub Stars: 24.2k, License: MIT Expat**
Gitlab CI/CD is a CI/CD feature available in Gitlab, an open-source and SaaS source code repository. Unlike Github Actions with limited free use, the self-hosted open-source version can use CI/CD features for free. Unlike Github Actions centered on individual workflows, Gitlab CI/CD can configure CI/CD by bundling multiple Jobs into Pipelines, and Auto DevOps can perform build, test, deployment, security checks, etc., all at once. Additionally, Auto Monitoring can monitor deployed applications, faithfully performing DevOps tool functions beyond CI/CD.

#### CD
**[Argo CD](https://github.com/argoproj/argo-cd), GitHub Stars: 21.3k, License: Apache License 2.0**
ArgoCD is a GitOps CD tool that uses Git as the deployment source. Declarative resource management is possible by matching Kubernetes resource states based on manifests written in Git, and thanks to GitOps characteristics of separately managing application source code (CI) and deployment source code (CD), fast deployment and rollback are possible without application builds when only resources or runtime settings change. Additionally, it has good extensibility, such as using various deployment strategies or setting deployment-related notifications by additionally applying Argo Rollouts or Argo CD Notifications.


### Container Registry
**[Harbor](https://github.com/goharbor/harbor), GitHub Stars: 27k, License: Apache License 2.0 <br>**
The most widely used container registry in the market, enabling easy synchronization not only with Private Docker Registry but also with major cloud providers' registries. It also supports chart repository functionality, enabling unified management of container images and packaged application resources in Harbor alone.
Until Harbor 2.8, it provided ChartMuseum-based chart repositories, but from version 2.8, ChartMuseum support was officially ended and OCI standard-based chart management systems were fully adopted. This greatly reduced chart repository metadata management burden and improved overall performance in storage, retrieval, and synchronization processes.
With additional bundles (plugins) like Trivy, a scanner finding container image vulnerabilities, and Notary, a tool for signing to ensure container image integrity, security can be enhanced through container image vulnerability checking and signature verification features, which can also be used identically for OCI standard-based charts, greatly enhancing chart security. All these features can be automated through Harbor API, advantageous for building DevSecOps pipelines. For these reasons, we included Harbor as the container registry.


### Container Native Storage
**[Rook](https://github.com/rook/rook): Container Native Storage Orchestration, GitHub Stars: 13.2k, License: Apache License 2.0 + [Ceph](https://github.com/ceph/ceph): Object Storage, GitHub Stars: 15.8k, License: LGPL version 2.1 or 3.0 <br>**
Rook is a container-native storage orchestration solution that helps use storage on Kubernetes. Longhorn is a similar tool. While the two tools have very similar basic features and structures, Rook can be used with Ceph, the industry's most widely used open-source distributed storage solution, providing familiarity advantages. Additionally, unlike Longhorn which only provides block storage, using Ceph enables simultaneous use of both block storage and object storage.

**[Velero](https://github.com/vmware-tanzu/velero): Cluster Data Management Tool, GitHub Stars: 9.6k, License: Apache License 2.0 <br>**
A tool that can manage data and volumes related to Kubernetes cluster resources. Velero can save cluster state data and volume snapshots and back up and restore them in coordination with object storage. These features can be usefully used for cluster disaster recovery and cluster environment migration.


### MLOps
**[Kubeflow](https://github.com/kubeflow/kubeflow), GitHub Stars: 15.3k, License: Apache License 2.0 <br>**
Data scientists and engineers can share work in Jupyter Notebooks deployed on Kubernetes clusters, and hyperparameter tuning needed for machine learning model training can be performed. Additionally, pipelines can be configured with models created this way, and Kubernetes jobs for training models can be handled on the web UI.


### Serverless
**[Knative](https://github.com/knative/serving), GitHub Stars: 5.9k, License: Apache License 2.0 <br>**
Serverless is a concept of running and stopping code whenever requested, rather than using fixed deployed services. Kubernetes can be utilized to maximize utility of this flexible approach. Knative is supported by Google and adopted by RedHat, IBM, etc., having high recognition and utility.



### Key Management Service
**[Vault](https://github.com/hashicorp/vault), GitHub Stars: 33.5k, License: BSL 1.1 <br>**
A sensitive information storage and management service made by Hashicorp. Without unified sensitive information management, permission management becomes difficult. Additionally, storing information like database passwords in plain text or having people enter directly creates high risk of leakage by attack. Especially when managing Secrets as YAML files without separate encryption, there's insecurity. When using Kubernetes and Vault together, sensitive information can be stored in Vault, then configured so only pods with that permission can access. Using Vault this way enables safe storage and systematic management of various sensitive information. In August 2023, Hashicorp product licenses changed to BSL, making it difficult to call open-source software anymore, but as there's no difference for general user use, it's still included.

### Container Runtime Management
**[ContainerD](https://github.com/containerd/containerd), GitHub Stars: 19.9k, License: Apache License 2.0 <br>**
From Kubernetes version v1.24, Dockershim built into Docker was removed, requiring use of container runtime tools like ContainerD. While CRI-O exists besides ContainerD, it's somewhat complex to configure and lacks many references, so we chose ContainerD. Currently, various managed and on-premise Kubernetes use ContainerD as the default container runtime.

### Virtualization Tools
**[KubeVirt](https://github.com/kubevirt/kubevirt), GitHub Stars: 6.5k, License: Apache License 2.0 <br>**
After VMware's acquisition by Broadcom, there have been many changes in virtualization-related licensing policies. Accordingly, there are many requirements to change virtualization tools. KubeVirt is one such alternative, but it doesn't actually replace virtualization as-is; rather, it re-implements virtualization on top of Kubernetes. Therefore, there's more complexity compared to traditional virtualization, with many parts unsupported or requiring knowledge compared to VMware. Nevertheless, organizations transitioning from virtualization to containers can experimentally consider adoption, and organizations already sufficiently proficient and operating Kubernetes can rather easily use virtualization on stable Kubernetes environments.

### Container Runtime Security
**[Falco](https://github.com/falcosecurity/falco), GitHub Stars: 8.4k, License: Apache License 2.0 <br>**
Falco is a project that graduated in March 2024. With many security incidents in 2024, 2025, and continuing into 2026, requirements are expected to increase further, so we changed the container runtime security tool to Falco, focusing on stability and more features rather than ease of use. Operations can be verified in real time for container runtime security, and operators can create and apply rules for real-time verification directly. Alerts created according to these rules can be delivered in various forms, enabling quick identification and action on problem situations.


### Data Pipeline (🎉 **Added** 🎉)
**[Strimzi](https://github.com/strimzi/strimzi-kafka-operator), GitHub Stars: 5.6k, License: Apache License 2.0 <br>**
Strimzi is an operator for running Apache Kafka on Kubernetes. It helps deploy and manage Kafka clusters in Kubernetes-native ways. Using Kubernetes Custom Resource Definitions (CRD), Kafka clusters, topics, users, etc., can be declaratively managed, supporting automated rolling updates and scaling. Additionally, various components of the Kafka ecosystem like Kafka Connect and Kafka MirrorMaker can be managed together, enabling effective construction of real-time data streaming pipelines on Kubernetes. This data pipeline plays a key role in stably supplying data needed for AI model training and inference services with low latency. Moreover, transmitting data event-based through Kafka instead of HTTP communication allows flexible adjustment of microservice scale and easy implementation of data reprocessing-related features during failures. Using reprocessing features ensures data consistency and greatly helps reproduce phenomena needed for model experiments. Therefore, large-scale traffic can be processed stably while collecting and delivering data cost-effectively.

**[ClickHouse](https://github.com/ClickHouse/ClickHouse), GitHub Stars: 44.3k, License: Apache License 2.0 <br>**
ClickHouse is a high-performance columnar database management system for real-time analytics. It provides fast query performance for large-scale datasets, optimized especially for log analysis, metric storage, and business intelligence (BI) workloads. ClickHouse can handle petabyte-scale data and has excellent compatibility with existing analysis tools through SQL support. While traditional data warehouses are optimized for batch processing of large-scale data, ClickHouse provides analysis results with low latency within seconds, enabling provision of high-level aggregated data needed for AI models based on this speed in business, operations, and other domains. This plays a key role in making fast decisions based on big data. In Kubernetes environments, clusters can be easily deployed and managed through the ClickHouse operator. By integrating with observability stacks like Prometheus and Grafana for long-term metric storage or building real-time data analysis pipelines in conjunction with Kafka, data value can be maximized, creating source data generation domains needed for AI model operation in faster cycles and increasing model development speed. Additionally, this can be extended to detect anomalies based on metrics to check if new features of models and microservices are operating normally.


### Observability

#### Log, Distributed Tracing, Metric Converter
**[OpenTelemetry](https://github.com/open-telemetry/opentelemetry-collector), GitHub Stars: 6.4k, License: Apache License 2.0**
A framework that helps collect, process, and deliver monitoring data like logs, traces, metrics, and profiles through standardized protocols (OTLP, OpenTelemetry Protocol) without dependency on specific observability solutions. Recently, the observability field is moving away from traditional methods where each solution installs proprietary agents to collect data, instead integrating data pipelines around OpenTelemetry-based standard protocols, with each solution developing toward enhancing usability, functionality, and visualization experience.
Applying OpenTelemetry-provided SDKs to applications or Kubernetes enables integrated delivery of monitoring data, based on which various OpenTelemetry-compatible observability solutions (Prometheus, Tempo, Pyroscope, etc.) can be naturally integrated.


#### Metric Pipeline
**[Prometheus](https://github.com/prometheus/prometheus): Metric Collection and Query, GitHub Stars: 61.5k, License: Apache License 2.0 <br>**
Shows high market share in Kubernetes monitoring, is CNCF's 2nd graduated project, and many CNCF and open-source projects publish metrics in Prometheus format for Prometheus to collect. From Prometheus 3.0, it supports improved remote read/write and can directly load metrics derived in OpenTelemetry format into Prometheus. Metric data collected and stored by Prometheus can be viewed through Grafana and built-in browsers.


#### Log Pipeline
**[Fluentbit](https://github.com/fluent/fluent-bit): Log Forwarder, GitHub Stars: 7.5k, License: Apache License 2.0 <br>**
Fluentbit is an open-source log forwarder. Its main advantage is stable high performance with low resource consumption. To send Kubernetes logs to log collection services, log content can be input through Fluentbit INPUT plugins for transmission to other services. Recently, Vector made by Datadog can be used for sending large volumes of log data. Vector provides ARC (Adaptive Request Concurrency) functionality to adjust transmission throughput of metrics and various data according to CPU performance when sending monitoring data including metrics, events, and logs to Elasticsearch, but wasn't selected as it doesn't yet have a user base as thick as Fluentbit.

(🔁 **Changed** 🔁)
**[OpenSearch](https://github.com/opensearch-project/OpenSearch): Log Storage and Search Engine, GitHub Stars: 12k, License: Apache License 2.0 <br>**
OpenSearch is an open-source project derived from Elasticsearch, the most widely used search engine tool. It provides search and log management features similar to Elasticsearch, can store unstructured data, and provides powerful text search capabilities based on Apache Lucene, making it very useful for storing and later searching logs and events. OpenSearch's biggest strength is maintaining pure Apache License 2.0, operating as completely open source. By departing from Elasticsearch's license change constraints and focusing on community-driven development, users can enjoy advantages of active community-based problem-solving ecosystems. Additionally, advantages include utilizing single sign-on, permission management, anomaly detection, and other features included in paid Elasticsearch and Kibana versions, and if direct configuration is cumbersome, it can be easily built and utilized using AWS-provided managed services. Especially, OpenSearch provides OpenSearch Dashboards derived from Kibana, Elasticsearch's user interface, providing convenience of immediately utilizing exploration features viewed in Kibana. In log storage strategies, storing frequently queried short-period log data using OpenSearch is common, but infrequently queried long-period log data can use a hybrid strategy of cost-intensive querying using Grafana-provided Loki. While such log data can be integrated into Grafana for understanding with other data, OpenSearch Dashboards may also be used for complex and detailed log-based analysis.


#### Trace Pipeline
(🔁 **Changed** 🔁)
**[Tempo](https://github.com/grafana/tempo): GitHub Stars: 4.9k, License: AGPL3.0<br>**
Tempo is a trace tool that collects events occurring in distributed microservices, mainly used to find bottlenecks or explore errors. Trace data generation is standardized by adding OpenTelemetry SDK during microservice development, and if you want to include more detailed tracking information, developers need to manually add spans.
Tempo can naturally integrate with Grafana visualization tool environments, making it easy to use. Additionally, unlike other tools, Tempo's cost-efficient storage method is a major advantage. Unlike existing trace tools, by storing data based on Trace ID without indexing all span tags and metadata, data storage costs are greatly reduced. Through these characteristics, it can be considered the optimal choice for linking trace data and metric data (additionally log data) based on the Grafana ecosystem.

#### Profile Pipeline (🎉 **Added** 🎉)
**[Pyroscope](https://github.com/grafana/pyroscope): Continuous Profiling, GitHub Stars: 11k, License: AGPL-3.0 <br>**
Pyroscope is an open-source continuous profile platform provided by Grafana. It helps debug application performance issues down to individual code lines and can track and analyze resource usage like CPU, memory, I/O over time. Pyroscope was born from merging the Pyroscope project started in 2021 and the Phlare project started by Grafana Labs in 2022. It has fast, scalable, and highly available storage and query capabilities, enabling efficient storage and retrieval of profile data even in large-scale environments. It's perfectly integrated with Grafana, enabling viewing of logs, metrics, traces, and profile data in one place.



#### Metric, Log, Distributed Trace, Profile, and External Data Visualization Tool

**[Grafana](https://github.com/grafana/grafana): Visualization Tool, GitHub Stars: 71k, License: AGPL-3.0 <br>**
Grafana is the de facto standard open-source tool for data visualization. Grafana's biggest strength is flexible integration capabilities for various data sources. Most tools collecting metric data basically support integration with Grafana, and beyond metric data integration, log data can be integrated using tools like OpenSearch and Loki. Additionally, trace data like Tempo and profile data through Pyroscope can be visualized. Beyond this, relational database data like PostgreSQL and analytical data like ClickHouse and BigQuery can be visualized. Data links that move to related content when clicking specific indicators in Grafana dashboards enable clear correlation analysis through problem-related data. Beyond visualization features, Grafana has built-in capabilities to send alerts to users when specific conditions (thresholds) are met. This is similar to Prometheus's Alertmanager but unlike Alertmanager which can only alert on Prometheus data, alerts can be sent based on data generated from Grafana data sources, enabling processing from alert to post-incident analysis in an integrated environment.



### Cluster Provisioners
**[kubeadm](https://github.com/kubernetes/kubeadm), GitHub Stars: 3.9k, License: Apache License 2.0 <br>**
The most widely used cluster provisioning CLI tool in Kubernetes, enabling simple command provisioning of control planes and setting multiple worker nodes to join the control plane API server. Beyond simply deploying by listing long kubeadm command lines, clusters can be provisioned using YAML-format configuration files.

**[kubespray](https://github.com/kubernetes-sigs/kubespray), GitHub Stars: 18k, License: Apache License 2.0 <br>**
Kubernetes clusters can be provisioned using Ansible playbooks. Compared to kubeadm, there's the advantage of configuring cluster control plane and worker nodes with single configuration when setting multiple control plane nodes.

**[Terraform](https://github.com/hashicorp/terraform), GitHub Stars: 47.2k, License: BSL 1.1 <br>**
Terraform is an Infrastructure as Code (IaC) management tool made by Hashicorp, helping manage cloud infrastructure by codifying it. Using providers provided by each cloud enables management of various platforms, making it the most widely used tool for infrastructure provisioning and effective for deploying Kubernetes. Like Vault, Hashicorp product licenses changed to BSL, making it difficult to call open-source software. For this reason, the OpenTofu project was forked and is currently managed by the Linux Foundation (LF). However, as there's no difference for general users using Terraform, and Terraform is verified at this time, we chose Terraform this year.

---

## Books Written Based on Standard Architecture

<a href="http://www.yes24.com/Product/Goods/102099414">
<img src="https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791165215743.jpg" width="300">
</a>

### Book Purchase Information
This book is available at various online and offline bookstores.
- 📍 [Kyobo Bookstore](https://bit.ly/3g1dsC7)
- 📍 [Aladin](https://bit.ly/3cpo37M)
- 📍 [YES24](https://bit.ly/3iq4L5W)
