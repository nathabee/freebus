# GitHub Pages Deployment for FreeBUS Project

## Description

This setup enables deploying the `freebus` as a static site on GitHub Pages using a dedicated `gh-pages` branch.

- **Source Directory**: The main project resides in `freebus`.
- **Index HTML**: The GitHub Pages index file is located in `frontend/github-pages/index.html`.
- **Static Export**: The Next.js app is compiled into a static website and exported to `frontend/out`.
- **Deployment Directory**: The compiled output (`index.html` + `out` directory) is moved to `freebus/gh-pages`, from which it is pushed to the `gh-pages` branch for deployment on GitHub Pages.

The `npm run demo-deploy` command builds and deploys the static site.
 

## Branch Initialization

Creating a separate clone of your repository dedicated to the `gh-pages` branch helps keep your development (`main`) and deployment (`gh-pages`) workspaces clean and isolated. Here’s how to set up `<path_to_ghpage>/freebus_ghpage` to track only the `gh-pages` branch.

### Step-by-Step Setup

### 1. **Clone the Repository for `gh-pages` Branch**  
First, create a new directory `freebus_ghpage` and clone the repository into it:
```bash
cd <somewhere on you local machine>
git clone https://github.com/nathabee/freebus.git freebus_ghpage

```

### 2 . Switch to the gh-pages Branch in the New Directory
If the gh-pages branch does not exist yet, you can create it in this clone:

```bash 
cd freebus_ghpage
git checkout --orphan gh-pages
git rm -rf .
echo "gh-pages branch initialized" > README.md
git add README.md
git commit -m "Initialize gh-pages branch"
git push -u origin gh-pages

```

## Updating the gh-pages Branch with New Code
When you want to update the gh-pages branch with new static content:

### Modify and test the code
Ensure the following files are updated in freebus/gh-pages/:
```bash 
index.html (is making a small presentation of the static website)
.nojekyll (so that github page is serving sub directories)
out  => ( directory containing the static export from competence-app)
README.md (for branch-specific instructions, manually updated as needed)
```


Command for test in local :

```bash 
cd freebus/frontend 
npm run demo-local-build
npm run demo-local-start
```

  

### Deploying on GitHub Pages
Switch to the Main Branch for Development
Go back to the main branch to make changes:



```bash 
cd freebus/frontend
git checkout  main
npm run demo-deploy


```
Now, the updated static files are deployed on GitHub Pages using the gh-pages branch.
 
 