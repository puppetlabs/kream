# TODO: Figure out logging
# TODO: Figure out how (if at all) to make vagrant up parallel in the background
#       One problem with this is the networking stack (have to manually select?)
#       Another is having to provide password for shared drive.

# Check your environment
Task PreChecks {
  $ServersYamlContent = Get-Content -Path "$PSScriptRoot/servers.yaml"
  ForEach ($Box in 'bento/centos-7.5','bento/ubuntu-16.04') {
    If ($ServersYamlContent -match $Box) {
      Write-Verbose "$Box is the current base image you are using"
      If ((vagrant box list | Where-Object -FilterScript {$_ -match $Box})) {
        Write-Verbose "You have the base image already locally downloaded"
      } Else {
        Write-Warning "The base image needs to be downloaded."
      }
    }
  }
}

# Build your cluster
Task Build {
  Write-Verbose "Deploying Kubernetes controller"
  vagrant up kube-master
  vagrant up kube-node-01
  vagrant up kube-node-02
  Write-Verbose 'Deploying worker nodes'
  Write-Verbose 'You can check their progress with "kubectl get nodes"'
}

# Spin up LB as a VM since it won't work as a container
Task LoadBalancer {
  Write-Verbose 'Can not install the LB on Mac OS due to networking limitation on Docker for mac'
  Write-Verbose 'Add "172.17.10.214 kubernetes" to /etc/hosts as a work around'
  Write-Verbose 'Bringing up vagrant load balancer'
  vagrant up lb
}

# Build HA Kubernetes Controllers
Task HAControllers -Depends LoadBalancer {
  Write-Verbose 'Deploying Kubernetes HA controllers'
  vagrant up kube-master
  vagrant up kube-replica-master-01
  vagrant up kube-replica-master-02
  Write-Verbose 'You can access your cluster with "kubectl get nodes"'
}

# Verify kubectl is installed
Task PostChecks {
  If (Get-Command 'kubectl' -CommandType Application -ErrorAction SilentlyContinue) {
    Write-Verbose 'Kubectl is installed'
  } Else {
    Throw 'Kubectl is not installed, please install using the following URL: https://kubernetes.io/docs/tasks/tools/install-kubectl/'
  }
}

# Set up local kubectl
Task Kubectl -Depends PostChecks{
  $FolderPath = "$PSScriptRoot/.kube/"
  If (!(Test-Path -Path $FolderPath)) {
    New-Item -Path $FolderPath -ItemType Directory -Force
  }
  vagrant ssh kube-master -c 'sudo cp /etc/kubernetes/admin.conf ~/kube-master/.kube/admin.conf && sudo chown vagrant:vagrant ~/kube-master/.kube/admin.conf > /dev/null 2>&1'
  Write-Verbose 'Configuring local Kubectl'
  $env:KUBECONFIG = "$PSScriptRoot/.kube/admin.conf" -replace '\\','/'
}

# Adds nodes to controllers after 'ClusterUpHA
Task AddNodes {
  Write-Verbose "Deploying worker nodes"
  vagrant up kube-node-01
  vagrant up kube-node 02
}

# Post tasks for ClusterUp
Task PostTasks {
  $Content = (Get-Content -Path "$PSScriptRoot/.kube/admin.conf") -replace '172.17.10.101:6443', 'kubernetes:6443'
  Set-Content -Path "$PSScriptRoot/.kube/admin.conf" -Value $Content -Encoding UTF8
}

# Delete your kubernetes cluster
Task CleanUp {
  Write-Verbose "Deleting your Kubernetes cluster"
  vagrant destroy --force
  If (Test-Path -Path "$PSScriptRoot/.log/") {
    Remove-Item -Path "$PSScriptRoot/.log/*.log" -Force
  }
}

Task ClusterUp    -depends PreChecks,Build,Kubectl
Task ClusterUpHA  -depends PreChecks,HAControllers,Kubectl,PostTasks
Task ClusterUpAll -depends PreChecks,HAControllers,AddNodes,Kubectl,PostTasks
