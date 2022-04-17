default: apply apply-helm

apply: apply-system apply-apps

apply-apps:
	kubectl kustomize --enable-alpha-plugins apps | kubectl apply -f -

apply-system:
	kubectl kustomize --enable-alpha-plugins system | kubectl apply -f -