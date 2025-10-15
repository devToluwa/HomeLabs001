# Linux Company Server Simulation Project

## 📖 Overview
This project is a **homelab simulation** of how a company IT department might provision and manage multiple servers.  
The aim is to practice **real-world sysadmin and infrastructure workflows**:  
 
- Defining consistent server roles (web, db, monitoring, backup, security).  
- Using **Ansible** for configuration management.  
- Managing configs and documentation like a real ops team.  
- Building towards scalable automation (Terraform, CI/CD, monitoring, etc.).  

This is both a **learning lab** and a **blueprint** for managing a small IT infrastructure.

---

## 🗂 Repo Structure
```
HomeLabs01/
├── ansible/ # Infrastructure-as-Code (playbooks, roles, inventory)
│ ├── inventory/ # Host definitions (hosts.ini)
│ ├── roles/ # Roles for each server type (web, db, monitoring, backup, security)
│ └── sites.yml # Main Ansible playbook
├── configs/ # Config snippets
├── docs/ # SOPs, setup guides, reference material
├── scripts/ # Helper/test scripts
└── README.md # Project overview (this file)
```

---


## 🖥️ Server Roles
Each VM simulates a company service:
- **Web** → hosts applications or websites.  
- **Database (DB)** → backend data storage.  
- **Monitoring** → observability stack.  
- **Backup** → data protection and recovery.  
- **Security** → hardened node for security tools or policies.  
 
---

## 📑 Documentation
See the `docs/` folder for step-by-step guides and SOPs:  

- [Samba Setup](docs/samba_setup.md)  

---

## 🚀 Workflow
1. **Provisioning**: PXE + Kickstart handles unattended VM installs.  
1. **Configuration Management**: Ansible roles apply server-specific configs.  
2. **Operations**: Documentation + scripts support day-to-day sysadmin tasks.
3. **Application Simulation**: Although not fully decided on this but I will simulate a full working application on this setup.  
4. **Scaling** (future): Future monitoring tools will be added to ensure seamless integration between servers.  

---

## 🎯 Goals
- Practice **sysadmin skills** in a controlled lab.  
- Learn **infrastructure automation** step by step.  
- Simulate a real company environment with multiple services.  
- Build a base to grow into **DevOps / Infra Engineer workflows** later.  

---

## 🧑‍💻 Author
Maintained by **Toluwa’s Homelabs**
Learning project on PXE, Kickstart, VMWare, and Linux Server Automation.  
Part of the *Linux Company Server Simulation Project*
