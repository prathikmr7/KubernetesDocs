
# 🚀 DevOps Notes: Kubernetes & MicroK8s

## 📦 Kubernetes Objects with Terraform
- Creating a new instance from a Terraform script.
- Enable user permissions using IAM policies.

## 🐧 MicroK8s (Ubuntu Only)

> **Note**: MicroK8s works **only on Ubuntu** systems.

### ✅ Installation Steps
- Follow Ubuntu-specific installation steps.
- After install, check if it’s running:
  ```bash
  microk8s status
  ```
- If not:
  ```bash
  microk8s start
  ```

### 📌 Use `kubectl` with MicroK8s:
```bash
microk8s kubectl get pods
```

### 🔁 Set alias for convenience:
```bash
alias kubectl='microk8s kubectl'
```

### 🧪 Check namespaces:
```bash
kubectl get ns
```

### 🔍 System Health Check:
```bash
kubectl get pods -n kube-system
```
This checks the status of control plane components.

## 🧱 Pods in Kubernetes

A **Pod**:
- Encapsulates **1 or more containers**
- Shares:
  - 🧭 Network: Same IP/ports
  - 💾 Storage: Shared volumes

> Think of a Pod as a wrapper around your app + the resources it needs.

### 🛠 Pod Creation Methods

1. **Imperative Way** — via command:
   ```bash
   kubectl run nginx --image=nginx
   ```
2. **Declarative Way** — via YAML:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: nginx
   spec:
     containers:
     - name: nginx
       image: nginx
       ports:
       - containerPort: 80
   ```

### 📖 Important Commands

| Command | Description |
|--------|-------------|
| `kubectl get` | Fetch resources |
| `kubectl describe pod <pod>` | Describe a pod |
| `kubectl apply -f pod.yml` | Apply a YAML manifest (create or update) |

### 🔄 What Happens When You Run a Command?

1. Hits **API Server**
2. Triggers **Kubelet**
3. Kubelet pulls image via **CRI (Container Runtime Interface)**
4. Pod is created on the **worker node**

### 📚 Understanding YAML

- YAML = Manifest file (key-value pairs)
- Names like `apiVersion`, `metadata.name` must follow:
  - Lowercase first word
  - Uppercase second word if compound

> Example:
```yaml
apiVersion: v1
```

Check schema:
```bash
kubectl explain pod
```

## 🧩 Labels in Kubernetes

> **Why use labels?**

- To **group** related pods
- To **target specific pods** for updates

```yaml
metadata:
  labels:
    app: myapp
```

## 🌀 ReplicaSets

> To handle traffic spikes, use **ReplicaSets** to scale pods.

📌 Documentation:  
https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/

### 🛠 Example: `rs.yaml`
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-rs
  labels:
    app: myapp
spec:
  replicas: 3
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

### 📌 Key Points:

- Pod auto-restarts if killed.
- Managed by **Control Manager**.
- Scale up by increasing `replicas`.

## 💡 Summary Tips

- Pods die when overwhelmed — ReplicaSet handles load.
- Use `kubectl describe pod <pod>` to trace events & ownership.
- Load is balanced by **kube-proxy**.
- ReplicaSets create identical pods for redundancy.
