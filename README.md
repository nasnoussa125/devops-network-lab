```markdown
# DevOps Network Lab

A comprehensive local laboratory designed to simulate enterprise infrastructure deployment, automation, monitoring, and validation.

## Architecture Overview

The laboratory environment consists of the following architectural blocks:
- **Service Modeling:** TOSCA Blueprint describing the global infrastructure topology.
- **Configuration Management:** Ansible inventory structures for node configuration management.
- **Containerized Infrastructure:** A multi-container Docker Compose stack isolating production services, CI/CD automation engines, and monitoring solutions.
- **Validation Suite:** Automated IVVQ (Integration, Verification, Validation, and Qualification) compliance frameworks.

## Repository Structure

```text
devops-network-lab/
├── ansible/
│   └── inventory/
│       └── hosts.ini
├── infrastructure/
│   ├── docker/
│   │   └── docker-compose.yml
│   └── monitoring/
│       └── prometheus.yml
├── ivvq/
│   └── scripts/
│       ├── run_local_tests.bat
│       └── run_tests.sh
└── tosca/
    └── blueprints/
        └── topology.yaml

```

## Prerequisites

* Docker Desktop (with active engine)
* Git Client
* Operating System: Windows (for local batch validation) or Linux/macOS (for shell evaluation)

## Getting Started

### 1. Environment Configuration

In compliance with SecOps best practices, sensitive credentials are decoupled from the source code. Create a `.env` file within the `infrastructure/docker/` directory before initialization:

```ini
DB_PASSWORD=YourSecurePasswordHere

```

### 2. Infrastructure Deployment

Navigate to the orchestration directory and initialize the containerized environment in the background:

```bash
cd infrastructure/docker
docker compose up -d

```

### 3. Exposed Services and Network Ports

Once deployment is complete, services are accessible on the following host endpoints:

| Component | Service | URL / Host Port | Architectural Note |
| --- | --- | --- | --- |
| **Nginx** | Web Server (Prod) | http://localhost:8080 | Standard port 80 isolated inside container |
| **Jenkins** | CI/CD Engine | http://localhost:8081 | Automated quality assurance workshop |
| **Prometheus** | Metrics Collector | http://localhost:9090 | Scrapes infrastructure and application targets |
| **Grafana** | Visualization Dashboards | http://localhost:3000 | Telemetry dashboards (Default: admin/admin) |
| **PostgreSQL** | Database Engine | localhost:5433 | Mapped to 5433 to avoid host allocation conflicts |

## Automated IVVQ Testing

The project incorporates automated test scripts to validate infrastructure state, syntactical compliance, and security posture.

### Local Windows Environment Validation

Execute the batch test suite from the root directory:

```cmd
ivvq\scripts\run_local_tests.bat

```

### Linux / Continuous Integration Pipeline Validation

Execute the shell test suite:

```bash
chmod +x ivvq/scripts/run_tests.sh
ivvq/scripts/run_tests.sh

```

### Test Specifications

* **[TEST-ANS-01]**: Validates the structural presence and integrity of the Ansible inventory database.
* **[TEST-TSC-01]**: Conducts a static check on the OASIS TOSCA blueprint structure.
* **[TEST-DKR-01]**: Verifies the definitions and requirements within the multi-container configuration.
* **[TEST-SEC-01]**: Executes an operational security (OPSEC) scan to block hardcoded database secrets in the deployment files.

```

```