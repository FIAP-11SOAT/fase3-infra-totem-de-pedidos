eks-update:
	aws eks update-kubeconfig --name challenge

tf-apply:
	cd terraform && terraform apply -auto-approve

tf-destroy:
	cd terraform && terraform destroy -auto-approve