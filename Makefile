default: apply apply-helm

apply:
	kubectl apply -k .

apply-helm:
	kubectl kustomize --enable-helm apps/transmission | kubectl apply -f -