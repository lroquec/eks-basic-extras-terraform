# YAML File Explanation for Autoscaler and External DNS Testing in EKS

## **autoscaler.yaml**

This file defines a **Deployment** and a **Service** to test the Kubernetes Cluster Autoscaler in an EKS environment.

### **Deployment**
- **`apiVersion: apps/v1`**: Specifies the version of the Deployment API.
- **`kind: Deployment`**: Declares a Deployment resource.
- **Metadata**:
  - `name: ca-test-deployment`: The name of the Deployment.
  - `labels: app: ca-nginx`: Labels to identify the application.
- **Spec**:
  - **Replicas**: `15`. The deployment starts with 15 replicas, creating enough resource demand to test the autoscaler.
  - **Selector**: Matches pods with the label `app: ca-nginx`.
  - **Template**:
    - **Containers**:
      - **`name: ca-nginx`**: The container name.
      - **`image: nginx`**: The official NGINX image.
      - **Resource Requests**:
        - CPU: `200m` (200 millicores).
        - Memory: `200Mi`.
      - **Ports**:
        - Exposes port `80`.

### **Service**
- **`apiVersion: v1`**: Specifies the Service API version.
- **`kind: Service`**: Declares a LoadBalancer Service.
- **Metadata**:
  - `name: ca-test-service-nginx`: The name of the Service.
  - Labels: Match the Deployment for traffic routing.
- **Spec**:
  - **Type**: `LoadBalancer`. Exposes the application externally via a cloud load balancer.
  - **Ports**:
    - External port: `80`.
    - Target port: `80`.

**Purpose**: This setup creates a scenario where resource demand triggers the Cluster Autoscaler to add nodes to the EKS cluster.

---

## **ingress-dns.yaml**

This file configures multiple applications in separate namespaces, each with its own Deployment, NodePort Service, and Ingress configuration. It also integrates with AWS ALB and ExternalDNS for Route53 record management.

### **Namespaces**
- Three namespaces are defined:
  - `ns-app1`
  - `ns-app2`
  - `ns-app3`

### **Deployments**
Each namespace includes a Deployment:
- **Spec**:
  - **Containers**:
    - Each deployment runs an NGINX-based application.
  - **Images**:
    - `ns-app1`: `stacksimplify/kube-nginxapp1:1.0.0`
    - `ns-app2`: `stacksimplify/kube-nginxapp2:1.0.0`
    - `ns-app3`: `stacksimplify/kubenginx:1.0.0`
  - **Replicas**: Set to `1`.

### **Services**
- **NodePort Services**:
  - Ports:
    - External ports: `30080` (app1), `30081` (app2), `30082` (app3).
    - Target port: `80`.
  - **Health Check Paths**:
    - `ns-app1`: `/app1/index.html`
    - `ns-app2`: `/app2/index.html`
    - `ns-app3`: `/index.html`

### **Ingress**
- **Ingress Resources**:
  - Defined for each namespace to route traffic to respective services.
  - **Annotations**:
    - AWS ALB settings:
      - `alb.ingress.kubernetes.io/scheme: internet-facing`: Exposes the ALB publicly.
      - **SSL Configuration**:
        - Listens on `443` (HTTPS) and `80` (HTTP).
        - Uses a specific SSL certificate (`alb.ingress.kubernetes.io/certificate-arn`).
        - Redirects HTTP to HTTPS.
      - **Health Checks**:
        - Configurable via annotations (e.g., `alb.ingress.kubernetes.io/healthcheck-path`).
    - **External DNS**:
      - Automatically creates Route53 DNS records:
        - Example: `external-dns.alpha.kubernetes.io/hostname: ingress-crossns-test.lroquec.com`.
  - **Rules**:
    - Define URL paths:
      - `/app1`: Routes traffic to `app1-nginx-nodeport-service`.
      - `/app2`: Routes traffic to `app2-nginx-nodeport-service`.

**Purpose**:
- **ExternalDNS**: Integrates with Route53 to automate DNS record creation.
- **Ingress**: Verifies application accessibility through specific paths.

