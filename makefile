.PHONY: traefik argo jaeger

minikube:
	minikube delete && minikube start --driver=docker --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0
	minikube addons disable metrics-server

traefik:
	cd traefik && \
	kubectl apply -f 00-role.yaml \
				-f 00-account.yaml \
				-f 01-role-binding.yaml \
				-f 02-traefik.yaml \
				-f 02-traefik-services.yaml
argo:
	cd argo && \
	kubectl apply -f 00-namespace.yaml && \
	kubectl apply -n argocd -k . && \
	kubectl apply -n argocd -f 02-ingress.yaml

jaeger:
	cd jaeger && \
	kubectl apply -f 00-namespace.yaml && \
	kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.54.0/jaeger-operator.yaml \
	-f 01-jaeger.yaml