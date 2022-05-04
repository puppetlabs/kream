# Kubernetes Development Environment:
```
Prerequisites:
- Vagrant
- Virtualbox v5.x 
- Ruby v2.3.3
```
# Basic setup instructions

## Install dependencies
```
git clone to a new directory
gem install bundler
bundle install
```
If you're on a Mac you will need Homebrew https://brew.sh/
Once brew is installed
```
brew install kubectl
```
On Linux
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.10.3/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```
Note this will install version 1.10.3, if you want a different version change the version in the url

## Run the cluster

The repo now supports running Kubernetes on both Ubuntu and Centos. By default it will use the Ubuntu base images.
If you want to use Centos just rename `servers.yaml` to `servers.yaml.debian` then rename `servers.yaml.rhel` to `servers.yaml`

To run the controller just issue the following commands from the root of the cloned repo
```
rake cluster_up
```
You will get an output like this. Please note the controller will take a couple of minutes
```
Checking if kubectl is installed
kubectl is installed
Configuring local Kubectl
To use kubectl issue 'export KUBECONFIG=.kube/admin.conf' in your terminal
Deploying Kuberntetes controller
[(    ● )] Deploying the Kubernetes controller... Kubernetes controller is ready
Deploying worker nodes
You can check there progress with
kubectl get nodes
```
If something goes wrong with your cluster at build time you will be able to look at the log file located `$CWD/.log/cluster-build.log`

## HA master development

If you are developing or making changes to the Puppet module for Kubernetes that changes the controller. You will need to run a separate command to build a cluster of 3 Kubernetes controllers with a load balancer. Before running up your cluster make sure you have run the [kubetool](https://github.com/puppetlabs/puppetlabs-kubernetes#setup) and move the generated hiera files a moved into the [hieradata](https://github.com/puppetlabs/kream/tree/master/hieradata) folder. Then issue the following command.
```
rake cluster_up_ha
```
You will get the following output

```
Can not install the LB on Mac OS due to networking limitation on Docker for mac
add '192.168.56.214 kubernetes' to /etc/hosts as a work around
Bringing up vagrant load balancer
Deploying Kuberntetes HA controllers
Checking for local Vagrant images
puppetlabs/ubuntu-16.04-64-puppet is the current base image you are using
You have the base image already locally downloaded
(   ●  ) Deploying the Kubernetes HA controller cluster... Kubernetes HA controller cluster is ready
You can access your cluster with 'kubectl get nodes'
Checking if kubectl is installed
kubectl is installed
Configuring local Kubectl
To use kubectl 'export KUBECONFIG=.kube/admin.conf' in your terminal
```

`192.168.56.214` is a load balancer that will balance the traffic across the 3 Kubernetes controllers.

## Helm

In addition to provisioning a kubernetes cluster, this repo also contains code to install and initialise helm on the kube-master. This code is stored in the modules directory of this environment. Until such time as the helm repo is made public it will be stored in this repo, after which it will be put into the puppetfile to ensure the latest version of the module is always used.

Complete documentation about the helm module and specific functionality can be found on the repo github page [here](https://github.com/puppetlabs/puppetlabs-helm) or the official helm documentation [here](https://docs.helm.sh/)

If you're on a mac you can install helm with homebrew
```
brew install kubernetes-helm
```
On Linux
```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

## Clean up
To clean up after you have finished with your nodes issue
```
rake cleanup
```

## Usage

To use the cluster after you have run `rake cluster_up` and `export KUBECONFIG=.kube/admin.conf` you can use your local `kubectl` to access the cluster.
A good exercise to see the cluster working correctly is checking out the Kube Dashboard. To do that issue the following commands
```
kubectl proxy
```
The dashboard will be available in your browser at  http://localhost:8001/ui

To use helm locally, run `helm init --client-only` and ensure your KUBECONFIG environment variable is correctly set.
```
$ helm init --client-only
$HELM_HOME has been configured at /Users/dave.try/.helm.
Not installing Tiller due to 'client-only' flag having been set
Happy Helming!
$
```

# About the project

## What is this repo actually doing ?
This repo is a a sandbox for the [Puppet Kubernetes module](https://forge.puppet.com/puppetlabs/kubernetes)

Please see the road map section of the README.md to see upcoming functionality and releases of the module.

## Limitations
Due to the changes in Kubernetes 1.6 with the auth structure changing to RBAC, the module will only support version 1.6 and above.

The master branch will be the stable branch with the release candidate for the project. The development branches will be named by road map features. Once the development branch is stable it will be merged into master. Please do try the development branches as it will be great to get feedback, just be aware they are still under heavy development.

## Road Map (For the module):
Here is the list of items that the module needs to at least get to a beta stage

 - [x] Multi node support
 - [x] HA controller support
 - [x] Support for both RHEL and Debian

## Road Map (For this repo)
Here is the functionality that is on the road map for this repo
 - [x] Add build functionality to the rakefile so once the master is up you can build multiple worker at the same time.
 - [x] Use the rakefile to configure the local kubectl client so the user does not need to ssh into a node
 - [x] Add Helm support



