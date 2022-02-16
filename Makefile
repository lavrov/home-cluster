default: apply apply-helm

apply:
	kubectl apply -k .

apply-helm:
	kubectl kustomize --enable-helm transmission | kubectl apply -f -