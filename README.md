# Docker Compose Stack
<p align="center">
  <img src="https://user-images.githubusercontent.com/77400522/193757315-cd73ce20-dd74-49a7-87e5-3d6ac7b7ddff.png">
</p>

nginx 웹서버의 설정 파일에서 다운스트림의 express 서버의 포트 3000번을 80번으로 매핑, 리버스 프록시를 구성하여 http로 들어오는 클라이언트의 요청에 응답하도록 하고 nginx와 express는 동일 네트워크에 속하도록 하여 해당 네트워크에 접근 가능하게 하며 몽고 디비와 express 서버를 같은 네트워크 브릿지로 묶어 외부에서 몽고 디비 컨테이너의 접근을 차단하도록 구성하였습니다.


# CircleCI
<p align="center">
  <img src="https://user-images.githubusercontent.com/77400522/193758114-151af45a-a9ee-4e22-b808-22feff7198e0.png">
</p>
workflow는 총 4단계로 구성하였고 aws 크레덴셜 유효성을 체크하는 job을 분리하여 유효성 실패시 조기에 실패하도록 구성하였으며 도커 허브 저장소는 현재 퍼블릭으로 유지중인 redmax45 계정의 저장소를 사용하였습니다.

### build-and-deploy 진행과정은 다음과 같습니다. 
- node 이미지 빌드, nginx 이미지 빌드 (몽고DB 이미지는 도커 컴포즈 빌드 시에 빌드됩니다.) 
- express 서버 reponse 200 응답 확인
- 첫 단계에서 빌드한 `노드 이미지`와 `nginx 이미지`, `redmax45/mongo:0.1 이미지`를 로컬에서 도커 컴포즈로 말아올린 후 ecr 저장소에 푸시합니다.
- ecs 컨테이너에 새 서비스를 업데이트한 후 어플리케이션 로드 밸런서 DNS 200 응답 확인
- [CircleCI 상세 과정](https://app.circleci.com/pipelines/github/ghdwlsgur/borough-market/211/workflows/b19a35bc-3f9a-4f8e-ad60-94f1e73446f1)

처음 테라폼 리소스 구성시에 ecs 컨테이너에 nginx 이미지만 띄워져 있어 nginx 페이지만 로드되지만 CI/CD를 진행한 후에 도커 컴포즈를 업데이트하여 서비스를 구성하도록 하였고 위 그림과 같이 도커 허브와 ECR 저장소에 등록되는 이미지는 동일해야 했으며 이를 위해 이미지 태그를 매번 실행시마다 변경되는 고유한 값인 CIRCLE_SHA1로 지정하여 워크로드 상 빌드 및 테스트를 완료한 후 최종적으로 ECR 저장소에 푸시 및 서비스 업데이트를 진행하도록 하였습니다. 



# AWS Architecture

### VPC 
<img width="1270" alt="image" src="https://user-images.githubusercontent.com/77400522/193803681-41737084-986b-4da4-9bd0-d17cbb1f1166.png">
대략적인 VPC 아키텍처는 다음과 같습니다. 퍼블릭 서브넷에 존재하는 라우팅 테이블은 인터넷 게이트웨이와 연결되어 퍼블릭 서브넷에 위치한 인스턴스에 공용 아이피를 할당할 경우 인터넷 게이트웨이를 통해 외부와 통신이 가능해집니다. 반면에 프라이빗 서브넷의 라우팅 테이블에는 인터넷 게이트웨이와 연결되어 있지 않아 외부와 통신이 불가능합니다. 본 아키텍처에서는 NAT Gateway나 NAT Device를 사용하지 않으므로 앞으로 생성할 EC2 인스턴스도 퍼블릭 서브넷안에서만 자동 확장하여 생성할 수 있게 설정하였습니다.



### Service
<img width="1262" alt="image" src="https://user-images.githubusercontent.com/77400522/193803741-5c1fa51b-3516-44e7-877c-0bc83a413ca4.png">
생성되는 전체 서비스는 다음과 같습니다. 앞서 설명드린 것처럼 Auto Scaling이 위치한 가용영역은 eu-central-1a, eu-central-1b, eu-central-1c가 되지만 퍼블릭 서브넷으로 범위를 한정하였습니다. 서비스 업데이트 시 ECR 저장소에 이미지를 푸시하고 해당 이미지를 도커 컴포즈로 말아올려 EC2 인스턴스의 세 개의 컨테이너를 올립니다. 


### Monitoring
<img width="1263" alt="image" src="https://user-images.githubusercontent.com/77400522/193803806-f82298f5-7906-41a9-84b2-a6aa9f72cb8f.png">
모니터링 구조는 다음과 같습니다. CI/CD 워크로드를 진행하기 전 최초 리소스 생성시 Nginx 컨테이너 하나만 생성되는데 이 컨테이너의 로그를 CloudWatch 로그로 추적합니다. CloudWatch Alarms는 테라폼 모듈로 구축한 리소스로 CPU, 메모리 사용률을 추적하여 기준치 알람을 전송하고 EC2 인스턴스의 오토스케일링을 진행합니다.


