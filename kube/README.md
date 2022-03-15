**Authenticate**

doctl kubernetes cluster kubeconfig save c2aea28d-1c3b-4070-83ff-387ff77c675f

**Configure registry**

https://docs.digitalocean.com/products/container-registry/how-to/use-registry-docker-kubernetes/

**Adding Secrets**

kubectl delete secret reef
kubectl create secret generic reef --from-env-file=.env.prod

kubectl delete secret pier
kubectl create secret generic pier --from-env-file=.env.prod

kubectl delete secret tidal
kubectl create secret generic tidal --from-env-file=.env.prod

**Using Secrets**

```yml
spec:
  containers:
    envFrom:
      - secretRef:
          name: reef
```
