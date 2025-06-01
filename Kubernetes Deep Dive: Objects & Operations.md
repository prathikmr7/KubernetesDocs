
# Kubernetes Deep Dive: Objects & Operations 🌐

Welcome to this repository, where we explore fundamental Kubernetes concepts, from setting up a local cluster with MicroK8s to managing application deployments using Pods and ReplicaSets. This guide walks through practical examples, command-line operations, and YAML definitions.

-----

## 🛠️ Kubernetes Cluster Setup (MicroK8s)

This section covers the installation and basic setup of MicroK8s, a lightweight Kubernetes distribution.

### MicroK8s Installation [cite: 82]

MicroK8s is designed for Ubuntu systems and can be easily installed using `snap`. 

```bash
sudo snap install microk8s --classic
```

After installation, you can verify its status: 

```bash
microk8s status
```

### Enabling Addons [cite: 83, 87, 88, 89]

MicroK8s allows enabling various addons for extended functionality, such as DNS, Helm, Dashboard, and more.
 

### Setting up `kubectl` Alias [cite: 91, 92]

To simplify `kubectl` commands, you can create an alias: 

```bash
alias kubectl="microk8s kubectl"
```

Verify namespaces: 

```bash
kubectl get ns
```

You can also check the health and status of system-critical pods: 

```bash
kubectl get pods -n kube-system
```

-----

## 📦 Kubernetes Pods: The Basics

Pods are the smallest deployable units in Kubernetes, encapsulating one or more containers (usually one). [cite: 96] They share the same IP address, ports, and can share storage volumes.

 

### Pod Creation Ways [cite: 101]

There are two primary ways to create Pods:

1.  **Imperative way:** Using commands. 
2.  **Declarative way:** Using YAML files (manifest files). 

#### Imperative Pod Creation Example 

To run an Nginx Pod imperatively: 

```bash
kubectl run nginx --image=nginx
```

This command creates a Pod that pulls the `nginx` image from Docker Hub and runs the default Nginx web server. 

Verify the Pod status: 
```bash
kubectl get pods
```

You can describe a specific Pod for detailed information: 

```bash
kubectl describe pod nginx
```



The `kubelet` component on the worker node is responsible for pulling the image and creating the Pod. 

#### Declarative Pod Creation Example 

For declarative creation, you define the desired state in a YAML file (e.g., `pod.yml`). 

Example `pod.yml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-declarative-way
spec:
  containers:
    - name: myapp
      image: nginx
      ports:
        - containerPort: 80
```

Apply the YAML file: [cite: 118]

```bash
kubectl apply -f pod.yml
```

The `kubectl apply -f` command is idempotent: it creates the resource if it doesn't exist or updates it if it does.

Verify the new Pod: 

```bash
kubectl get pods
```



**YAML Naming Conventions:** In YAML, the first name in a key should be lowercase, and if there are two names, the second name should start with a capital letter (e.g., `apiVersion`)

You can get more information about Pod fields using `kubectl explain pod`. 

Metadata names should be given exactly two spaces for proper parsing. [cite: 201] The name inside the container is the container name, while the name inside metadata is the Pod name.


Official Kubernetes Pods documentation: [Using Pods](https://kubernetes.io/docs/concepts/workloads/pods/) 


Pods can also be defined in JSON format.

-----

## 📈 Scaling with ReplicaSets

Pods handle application instances. If traffic increases, you need to increase the number of Pods to handle the load; otherwise, a single Pod might get killed. 


The `kube-proxy` component is responsible for distributing traffic equally among Pods.To have multiple Pods with the same configuration, you enable `REPLICAS` using a `ReplicaSet`. [cite: 139, 214]

Official Kubernetes ReplicaSet documentation: [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)


### ReplicaSet YAML Example 

When defining a ReplicaSet, you'll notice a `GROUP` in its API version, which is not present in normal Pods.

Example `rs.yaml`:

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-rs
  labels:
    app: myapp
spec:
  replicas: 3 # Example: desired number of replicas
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: myapp
          image: nginx
          ports:
            - containerPort: 80
```



### Why Labels? 

Labels are used to group multiple Pods, making it easier to manage and modify specific groups of Pods without affecting others.



After deleting the pods: 
```bash
kubectl delete pod nginx
kubectl delete pod nginx-declarative-way
```

Creating a new `rs.yaml` file: 


Once created, you can see the ReplicaSet: 

If a replica pod is deleted, it will automatically be re-created by the Control Manager, which is responsible for maintaining the replica set. [cite: 150]

-----
