resource "aws_ecs_cluster" "jenkins_server" {
  name = "jenkins-server"
}


resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "jenkins"
      image     = "jenkins/jenkins"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        },
        {
          containerPort = 50000
          hostPort      = 50000
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

}

resource "aws_ecs_service" "mongo" {
  name            = "jenkins_ecs_service"
  cluster         = aws_ecs_cluster.jenkins_server.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
}