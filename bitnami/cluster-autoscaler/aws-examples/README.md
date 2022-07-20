# Deploy Cluster Autoscaler on AWS

> NOTE: If you are pulling from a private containers registry, replace the image name with the full URL to the docker image. E.g.
> 
> ```
> containers:
>   - image: 'your-registry/cluster-autoscaler:your-version'
> ```

Run the command below to create the RBAC requirements to deploy Cluster Autoscaler on your cluster:

```bash
kubectl apply -f rbac-requirements.yaml
```

The following K8s resources will be created:

- A **serviceAccount** with name cluster-autoscaler in the `kube-system` namespace. 
- A **role** in the `kube-system` namespace.
- A **roleBinding** which binds the serviceAccount created with the corresponding role.
- A **clusterRole**.
- A **clusterRoleBinding** which binds the serviceAccount created with the corresponding clusterRole.

Once you accomplish RBAC requirements, deploy Cluster Autoscaler on the cluster with one of the specifications below:

- 1 ASG Setup (use cluster-autoscaler-one-asg.yaml)
- Multiple ASG Setup (use cluster-autoscaler-multi-asg.yaml
- Master Node Setup (use cluster-autoscaler-run-on-master.yaml)
- Auto-Discovery Setup (use cluster-autoscaler-autodiscover.yaml)

You just need to run the command below:

```bash
kubectl apply -f DEPLOYMENT-SPECIFICATIONS.yaml
```

Find more information about deployments specifications in the [official docs](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws#deployment-specification).
