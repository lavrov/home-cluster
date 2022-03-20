default: apply apply-helm

apply:
	kubectl kustomize --enable-alpha-plugins . | kubectl apply -f -

apply-helm:
	kubectl kustomize --enable-helm apps/transmission | kubectl apply -f -