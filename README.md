Setup Notes

1. Connect Nautilus to GitHub via SSH
        SSH from Nautilus JupyterHub / dev pod (interactive)
        
        This is the easiest path for cloning/pushing while you’re working in notebooks or a long-running pod.
        
        1) Check if a key already exists
        
        Open a Terminal in Nautilus and run:
        
        ls -al ~/.ssh
        
        
        If you see id_ed25519 (or id_rsa) and a corresponding .pub, you already have a key there.
        
        2) If there’s no key (or you want a fresh one), generate it
        ssh-keygen -t ed25519 -C "your_email@example.com"
        
        
        Press Enter for the default path (~/.ssh/id_ed25519). GitHub recommends ed25519 keys. 
        GitHub Docs
        +1
        
        3) Add the public key to GitHub
        
        Print the public key:
        
        cat ~/.ssh/id_ed25519.pub
        
        
        Copy that into GitHub → Settings → SSH and GPG keys → New SSH key. 
        GitHub Docs
        +1
        
        4) Set safe permissions (important on shared systems)
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/id_ed25519
        chmod 644 ~/.ssh/id_ed25519.pub
        
        5) (Optional but nice) Force GitHub to use that key
        
        Create/edit ~/.ssh/config:
        
        nano ~/.ssh/config
        
        
        Add:
        
        Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
        
        6) Test auth, then clone
        ssh -T git@github.com

       7) Add global config to Nautilus environment
       git config --global user.name "Your Name"
       git config --global user.email "your_github_email@example.com"

   
3. Clone repo into Nautilus
   
## Docker Image: Build & Push to GitHub Container Registry (GHCR)

This project ships as a Docker image published to **GitHub Container Registry (GHCR)**:

`ghcr.io/benclark772/8420_module_5:latest`

You can either:

1. **Build & push the image manually** from your local machine, or  
2. **Let GitHub Actions build & push automatically** whenever you push to `main`.

---

### 1. Manual Build & Push

#### 1.1 Prerequisites

- **Docker** installed and running (Docker Desktop on Windows/macOS is fine)
- A **GitHub Personal Access Token (classic)** with scopes:
  - `read:packages`
  - `write:packages`
  - (optional) `delete:packages` if you need to delete images

> ⚠️ Never commit your token to Git, scripts, or share it in screenshots.

---

#### 1.2 Log in to GHCR

From a terminal (bash example):

```bash
# Replace with your GitHub username and PAT
export GHCR_USER="benclark772"
export GHCR_PAT="<YOUR_GHCR_PAT>"

echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USER" --password-stdin
