# helm

## NOTE

At present this module is requires a working kubernetes cluster, with kubectl installed.
In addition to this it is recommended that a service account be setup in the desired namespace
before installation of helm to use full functionatlity.

See here for more information:

https://github.com/kubernetes/helm/issues/2224



#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with helm](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The helm module installs, configures and manages the helm package manager.

This module manages both the installation of the helm client and helm server. In addition to this it will manage helm deployments

## Setup

To install with the default options:
`include helm`

## Usage

To customise options, such as the version of helm, or the service account and namespace of the tiller deployment:

```
class { 'helm':
  version => '2.6.0',
  service_account => 'my_account',
  tiller_namespace => 'my_namespace',
}
```

To create a helm chart

```
helm::create { 'myapp':
  env        => $env,
  chart_path => '/tmp',
  chart_name => 'myapp',
  path       => $path,
}
```

To package a chart

```
helm::package { 'myapp':
  chart_path  => '/tmp',
  chart_name  => 'myapp',
  destination => '/root',
  env         => $env,
  path        => $path,
  version     => '0.1.0',
}
```

To deploy a helm chart

```
helm::chart { 'mysql':
  ensure       => present,
  chart        => 'stable/mysql',
  env          => $env,
  path         => $path,
  release_name => 'mysql',
}
```

To add a helm repository

```
helm::repo { 'myrepo':
  ensure => present,
  env    => $env,
  path   => $path,
  repo_name => 'myrepo',
  url       => 'http://myserver/charts'
}
```

To update helm repositories

```
helm::repo_update { 'update':
  env => $env,
  path => $path,
  update => true
}
```
## Reference

### Public classes

#### Class: `helm`

Guides the basic setup and installation of Helm on your system.

When this class is declared with the default options, Puppet:

- Downloads and installs the specified helm version on your system.
- Creates the cluster role and service accounts required to run tiller.
- Deploys the helm server (Tiller) into the `kube-system` namespace.

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`

##### `init`

A flag to initialise the helm install and deploy the Tiller pod to Kubernetes

Values: `'true', 'false'`

Default: `true`

##### `install_path`

Sets the path variable for exec types in the module

Default: `['bin','/usr/bin']`

##### `service_account`

The name of the service account assigned to the `tiller` deployment

Default: `tiller`

##### `tiller_namespace`

The namespace to deploy tiller into

Default: `kube-system`

##### `version`

The version of helm to install

Default: `2.5.1`

### Private classes

#### Class: `helm::binary`

Downloads and extracts the helm binary

#### Class: `helm::account_config`

Configures the service account and cluster role required to deploy helm

#### Class: `helm::config`

Calls the `helm::helm_init` define to deploy tiller to the kubernetes cluster.


### Defines

#### `helm::create`

Creates a new chart by running `helm create`

##### `chart_name`

Default: `undef`

The name of the helm chart

##### `chart_path`

The file system location of the chart.

Note: If directories in the given path do not exist, Helm will attempt to create them as it goes. If the given destination exists and there are files in that directory, conflicting files will be overwritten, but other files will be left alone

Default: `undef`

##### `debug`

Enable verbose output

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `path`

Values for PATH environment variable

Default: `undef`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`


#### `helm::chart`

Manages the deployment of helm charts

##### `ensure`

A flag to determine whether a chart should be deployed

Values: `'present','absent'`

Default: `present`

##### `ca_file`

Verify certificates of HTTPS-enabled servers using this CA bundle

Default: `undef`

##### `cert_file`

Identify HTTPS client using this SSL certificate file

Default: `undef`

##### `debug`

Enable verbose output

Values `'true','false'`

Default: `false`

##### `devel`

Use development versions

Default: `false`

##### `dry_run`

Simulate an install or delete of a deployment

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `undef`

##### `key_file`

Identify  HTTPS client using thie SSL key file

Default: `undef`

##### `keyring`

Location of the public keys used for verification

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `name_template`

Template used to name the release

Default: `undef`

##### `no_hooks`

Prevent hooks from running during install

Default: `false`

##### `path`

Values for PATH environment variable

Default: `undef`

##### `purge`

Remove the release from the store and make its name free for later use

Default: `true`

##### `release_name`

Release name. This value is required

Default: `undef`

##### `replace`

Reuse the given name

Default: `false`

##### `repo`

Chart reposistory URL for the requested chart

Default: `undef`

##### `set`

Set array of values for the `helm create` command

Default: `[]`

##### `timeout`

time in seconds to wait for any individual Kubernetes operation

Default: `undef`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`

##### `tls`

Enable TLS

Default: `false`

##### `tls_ca_cert`

Path to TLS CA certificate file

Default: `undef`

##### `tls_cert`

Path to TLS certificate file

Default: `undef`

##### `tls_key`

Path to TLS key file

Default: `undef`

##### `tls_verify`

Enable TLS for request and verify remote

Default: `undef`

##### `values`

Specify values from a YAML file, can take multiple values in an array

Default: `[]`

##### `verify`

Verify the package before installing it

Default: `false`

##### `version`

Specify the exact chart version to install. If this is not specified, the latest version is installed

Default: `undef`

##### `wait`
 if set, will wait until all Pods, PVCs, Services, and minimum number of Pods of a Deployment are in a ready state before marking the release as successful. It will wait for as long as `timeout`

Default: `false`


#### `helm::helm_init`

Deploys the tiller pod and initialises the helm client

##### `init`

A flag to deploy the tiller pod and initialise the helm client

Values: `'true','false'`

Default: `true`

##### `canary_image`

Use the canary tiller image

Values: `'true','false'`

Default: `false`

##### `client_only`

If true, this does not deploy tiller

Values: `'true','false'`

Default: `false`

##### `debug`

Enable verbose output

Values `'true','false'`

Default: `false`

##### `dry_run`

Simulate an install or delete of a deployment

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `local_repo_url`

URL for the local repository

Default: `undef`

##### `net_host`

Install Tiller with net=host

Values: `'true','false'`

Default: `false`

##### `path`

Values for PATH environment variable

Default: `undef`

##### `service_account`

Name of the service account for the tiller deployment

Default: `false`

##### `skip_refresh`

Do not refresh (download) the local repository cache

Values: `'true','false'`

Default: `false`

##### `stable_repo_url`

URL for stable repository

Default: `undef`

##### `tiller_image`

Override Tiller image

Default: `undef`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`

##### `tiller_tls`

Install Tiller with TLS enabled

Values: `'true','false'`

Default: `false`

##### `tiller_tls_cert`

Path to TLS certificate file to install with Tiller

Default: `undef`

##### `tiller_tls_key`

Path to TLS key file to install with Tiller

Default: `undef`

##### `tiller_tls_verify`

Install Tiller with TLS enabled and to verify remote certificates

Values: `'true','false'`

Default: `false`

##### `tls_ca_cert`

Path to CA root certificate

Default: `false`

##### `upgrade`

Upgrade if Tiller is already installed

Values: `'true','false'`

Default: `false`

#### `helm::package`

##### `chart_name`

Default: `undef`

The name of the helm chart

##### `chart_path`

The file system location of the chart.

##### `debug`

Enable verbose output

Values `'true','false'`

Default: `false`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `save`

Save packaged chart to local chart repository

Values: `'true','false'`

Default: `true`

##### `sign`

Use a PGP private key to sign this package

Values: `'true','false'`

Default: `false`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`

##### `version`

Set the version of the chart

Default: `undef`

#### `helm::repo`

##### `ca_file`

Verify certificates of HTTPS-enabled servers using this CA bundle

Default: `undef`

##### `cert_file`

Identify HTTPS client using this SSL certificate file

Default: `undef`

##### `debug`

Enable verbose output

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `undef`

##### `key_file`

Identify  HTTPS client using thie SSL key file

Default: `undef`

##### `no_update`

Raise error if repo is already registered

Values `'true','false'`

Default: `false`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `path`

Values for PATH environment variable

Default: `undef`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`

##### `repo_name`

Name of the remote repository

Default: `undef`

##### `url`

URL for the remote repository

Default: `undef`

#### `helm::repo_update

A define to update helm repos.

Note, as per the default behaviour of helm this updates all repos

##### `debug`

Enable verbose output

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `path`

Values for PATH environment variable

Default: `undef`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`

##### `update`

A flag to set whether the repo should be updated

Values `'true','false'`

Default: `true`


## Limitations

This module is only compatible with the `Linux` kernel

## Development

### Contributing

[Puppet][] modules on the [Puppet Forge][] are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve.

We want to make it as easy as possible to contribute changes so our modules work in your environment, but we also need contributors to follow a few guidelines to help us maintain and improve the modules' quality.

For more information, please read the complete [module contribution guide][] and check out [CONTRIBUTING.md][].
