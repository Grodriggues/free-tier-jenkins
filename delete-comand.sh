aws ecs list-container-instances --cluster jenkins-server

aws ecs deregister-container-instance --cluster jenkins-server --container-instance 1e0a780a008c43378932bf7e914fe6f5 --force