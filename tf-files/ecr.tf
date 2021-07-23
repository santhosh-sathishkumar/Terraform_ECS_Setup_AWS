# Create a ECR repo in AWS

resource "aws_ecr_repository" "main-ecr" {
    name = "ecr-repo-reactjs"
    image_tag_mutability = "MUTABLE"
}

# Add life cycle policy to the repo, to delete older images

resource "aws_ecr_lifecycle_policy" "lifecyle" {
    repository = aws_ecr_repository.main-ecr.id

    policy = <<EOF
    {
       "rules": [
            {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
                 }
            }
       ]
    }
    EOF
  
}