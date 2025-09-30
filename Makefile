eks-update:
	aws eks update-kubeconfig --name fase3-infra-totem-de-pedidos-eks-cluster

tf-apply:
	cd terraform && terraform apply -auto-approve

tf-destroy:
	cd terraform && terraform destroy -auto-approve