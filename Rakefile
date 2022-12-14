require 'rake'
require 'bundler'
require 'fileutils'
require 'tty-spinner'
require 'logger'
require 'os'
require 'yaml'
require 'net/scp'
require 'net/ssh'

def logs(servername)
  directory_name = "#{Dir.pwd}/.log/"
  Dir.mkdir(directory_name) unless File.exist?(directory_name)
  STDOUT.reopen("#{Dir.pwd}/.log/#{servername}.log", 'w')
  logger = Logger.new($stdout)
end

desc 'check your environment'
task :pre_checks do
  def pre_check
    puts 'Checking for local Vagrant images'
    boxes = ['bento/centos-7.5', 'bento/ubuntu-16.04']
    boxes.each do |box|
      dist = File.read("#{Dir.pwd}/servers.yaml")
      installed = dist.include?(box)
      next unless installed == true
      puts "#{box} is the current base image you are using"
      vagrant = system("vagrant box list | grep -ow #{box} > /dev/null 2>&1")
      if vagrant == true
        puts 'You have the base image already locally downloaded'
      else
        puts "The base image needs to be downloaded.\nplease tail #{Dir.pwd}/.log/cluster-build.log for progress"
      end
    end
  end
  pre_check
end

desc 'Build your cluster'
task :build do
  def kube_controller
    puts 'Deploying Kuberntetes controller'
    spinner = TTY::Spinner.new(':spinner :title', format: :bouncing_ball)
    spinner.auto_spin

    logs('kube-master')
    spinner.update(title: 'Deploying the Kubernetes controller ...')
    system('vagrant up kube-master')

    logs('kube-node-01')
    spinner.update(title: 'Deploying kube-node-01')
    system('vagrant up kube-node-01')

    logs('kube-node-02')
    spinner.update(title: 'Deploying kube-node-02')
    system('vagrant up kube-node-02')

    spinner.update(title: 'Cluster deployed successfully')
    spinner.success
  end
  kube_controller
end

desc 'Build HA Kubernetes controllers'
task :ha_controllers do
  def kube_controller_ha
    def lb
      puts 'Checking to see if you have the load balancer image locally'
      image = system('docker images | grep -ow puppet/nginx > /dev/null 2>&1')
      if image == true
        puts 'You have the image puppet/ngnix locally'
      else
        puts 'Building the load blancer image puppetlabs/nginx'
        system('cd lb && docker build -t puppet/nginx . > /dev/null 2>&1')
             end
      puts 'Running the load balancer'
      system('docker run -d --net=host --name nginx puppet/nginx > /dev/null 2>&1')
    end

    if OS.linux? == true
      lb
    elsif OS.mac? == true
      puts 'Can not install the LB on Mac OS due to networking limitation on Docker for mac'
      puts "add '192.168.56.214 kubernetes' to /etc/hosts as a work around"
      puts 'Bringing up vagrant load balancer'
      pidlb = fork do
        logs('lb')
        system('vagrant up lb')
      end
     end
    puts 'Deploying Kuberntetes HA controllers'
    puts 'Checking for local Vagrant images'
    spinner = TTY::Spinner.new(':spinner Deploying the Kubernetes HA controller cluster...', format: :bouncing_ball)
    spinner.auto_spin
    pid1 = fork do
      logs('kube-master')
      system('vagrant up kube-master')
    end
    pid2 = fork do
      sleep 3
      logs('kube-replica-master-01')
      system('vagrant up kube-replica-master-01')
    end
    pid3 = fork do
      sleep 5
      logs('kube-replica-master-02')
      system('vagrant up kube-replica-master-02')
    end
    Process.wait pid3
    ex = $?.exitstatus
    if ex = !0
      puts "Something went wrong ! see #{Dir.pwd}/.log/<server_name>.log for details"
      exit 1
           end
    spinner.stop('Kubernetes HA controller cluster is ready')
    puts "You can access your cluster with 'kubectl get nodes'"
      end
  kube_controller_ha
end

desc 'Set up local Kubectl'
task :kubectl do
  def post_checks
    puts 'Checking if kubectl is installed'
    if File.exist?('/usr/local/bin/kubectl') || File.exist?('/usr/bin/kubectl')
      puts 'kubectl is installed'
    else
      puts 'Kubectl is not installed, please install using the following'
      puts 'https://kubernetes.io/docs/tasks/tools/install-kubectl/'
    end
  end

  def kubectl
    directory_name = '.kube/'
    Dir.mkdir(directory_name) unless File.exist?(directory_name)
    system("vagrant ssh kube-master -c 'sudo cp /etc/kubernetes/admin.conf ~/share/.kube/ && sudo chown vagrant:vagrant admin.conf > /dev/null 2>&1'")
    puts 'Configuring local Kubectl'
    puts "To use kubectl 'export KUBECONFIG=.kube/admin.conf' in your terminal"
  end
  post_checks
  kubectl
end

desc "Add's nodes to controllers after 'rake cluster_up_ha'"
task :add_nodes do
  pid1 = fork do
    system('vagrant up kube-node-01 > /dev/null 2>&1')
  end
  pid2 = fork do
    system('vagrant up kube-node-02 > /dev/null 2>&1')
  end
  puts 'Depolying worker nodes'
  puts "To check the progress use 'kubectl get nodes'"
end

desc 'Post tasks for cluster_up'
task :post_tasks do
  File.write('.kube/admin.conf', File.open('.kube/admin.conf', &:read).gsub('192.168.56.101:6443', 'kubernetes:6443'))
end

desc 'Delete your Kubernetes cluster'
task :cleanup do
  system("vagrant\tdestroy -f > /dev/null 2>&1")
  system('rm -f .log/*.log')
  puts 'Deleting your Kuberntes cluster'
end

desc 'Automate the full build of your Kubernetes cluster'
task cluster_up: %i[
  pre_checks
  build
  kubectl
]

desc 'Automate the full build of your HA Kubernetes controllers'
task cluster_up_ha: %i[
  pre_checks
  ha_controllers
  kubectl
  post_tasks
]

desc 'Automate the full build of 3 controller and 2 nodes'
task cluster_up_all: %i[
  pre_checks
  ha_controllers
  add_nodes
  kubectl
  post_tasks
]
