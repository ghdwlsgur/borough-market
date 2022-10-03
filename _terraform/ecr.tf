# ECR Private Repository를 생성합니다. 
# Repository URI는 다음과 같은 형식을 가지게 됩니다.
# ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${local.aws_ecr_repository_name}
resource "aws_ecr_repository" "borough-market" {
  name = local.aws_ecr_repository_name

  # Repository에 대한 태그 변경을 가능하게 설정합니다.
  image_tag_mutability = "MUTABLE"

  # 이미지가 리포지토리로 푸시된 후 스캔됩니다. 
  image_scanning_configuration {
    scan_on_push = true
  }
}
