# **shell-scripts**
A collection of Bash shell, CMD batch, and PowerShell scripts to automate tasks in the terminal.

Below is a list of the various scripts and a short summary of what they do.

## **Bash**

### **```repo_manager.sh```**

Many times, if you come across a GitHub repository that you find interesting or 
useful, would like to add onto or reference later, you have the option of 
starring or forking the repository. However, if the repository is deleted 
or made private, you will no longer have access to it in your starred 
repositories list on your GitHub account. Similarly, if the forked repository, 
which happened to be a private repository on which you were a collaborator, is
deleted, then your fork of the repository is also deleted from your account. 
Additionally, the forking and starring of repositories clutters your GitHub 
profile.

One way to get around this is to create a private repository on your account 
and clone the other repositories of interest into it. Git does not have the 
ability to commit and push repositories that contain other repositories. To get 
around this, we have Git submodules. Submodules act as references to other 
GitHub repositories which are essential to your repository. However, the same 
problem still persists. If the original repository being referenced is deleted, 
then the link to the original repository is broken. You will not be able to 
clone your personal collection from your remote account onto another machine, 
and the only clone containing the full code contained in the repository of 
interest that used to exist will be the original copy of your collection. If 
this copy is misplaced, then you have no chances of obtaining the lost code.

To get around this, I created a script that manages a collection of cloned 
GitHub repositories. With this script, users can add repositories to their 
collection, update repositories to obtain the latest version, provided the 
original repository still exists on, or remove a repository from the 
collection. It gets around Git's inability to commit and push nested 
repositories by storing a full copy of the repositories of interest within a 
single repository that you can commit and push to a service such as GitHub or 
GitLab.

### **```teleport.sh```**

If you have many directories on your machine that you navigate into and work in 
several times a day, it can get tedious to have to navigate into those 
directories from your home directory manually. This script allows users to add 
the paths of directories they work in routinely as well as a nickname for them. 
When the user runs the script and specifies a nickname for a directory, they 
are automatically *teleported* to the directory. Users reach the desired 
location without having to type multiple commands where the navigate 
directory by directory or one long command.

This script was originally created by my friend Amanuel. Check out his GitHub page [here](https://github.com/AmanuelEphrem)! I have slightly modified it.