require 'rake'
require 'bundler'
require 'fileutils'
require 'tty-spinner'
require 'logger'
require 'os'
require 'yaml'
require 'net/scp'
require 'net/ssh'

desc "Build your cluster"
task :build  do
	def kube_controller
	  def logs
	    directory_name = "#{Dir.pwd}/.log/"
	    Dir.mkdir(directory_name) unless File.exists?(directory_name)
	    STDOUT.reopen("#{Dir.pwd}/.log/cluster-build.log", "w")
            logger = Logger.new($stdout)
	  end
	  def pre_checks
	    boxes = ['bento/centos-7.4', 'bento/ubuntu-16.04']
            boxes.each do |box|
              dist = File.read("#{Dir.pwd}/servers.yaml")
              installed = dist.include?(box)
              if installed == true
                puts "#{box} is the current base image you are using"
                vagrant = system("vagrant box list | grep -ow #{box} > /dev/null 2>&1")
                if vagrant == true
                  puts "You have the base image already locally downloaded"
                else
                  puts "The base image needs to be downloaded.\nplease tail #{Dir.pwd}/.log/cluster-build.log for progress"
                end
	      end
            end
          end
	  puts "Deploying Kuberntetes controller"
          puts "Checking for local Vagrant images"
          pre_checks
	  spinner = TTY::Spinner.new(":spinner Deploying the Kubernetes controller...", format: :bouncing_ball)
	  spinner.auto_spin
	  pid1 = fork do
            logs
	    system("vagrant up kube-master")
          end
	  Process.wait pid1
	  ex = $?.exitstatus
	  if ex =! 0
	    puts "Something went wrong ! see #{Dir.pwd}/.log/cluster-build.log for details"
	    exit 1
          end
	  spinner.stop('Kubernetes controller is ready')
	  pid2 = fork do
	    logs
	    system("vagrant up kube-node-01")
	  end
          pid3 = fork do
	    logs
	    system("vagrant up kube-node-02")
          end
          puts "Depolying worker nodes"
          puts "You can check there progress with 'kubectl get nodes'"
        end
     kube_controller
end

#TODO fix repetitive code

desc "Build HA Kubernetes controllers"
task :ha_controllers do
    def kube_controller_ha
       def lb
         puts "Checking to see if you have the load balancer image locally"
         image = system('docker images | grep -ow puppet/nginx > /dev/null 2>&1')
	 if image == true
           puts "You have the image puppet/ngnix locally"
         else
           puts "Building the load blancer image puppetlabs/nginx"
	   system('cd lb && docker build -t puppet/nginx . > /dev/null 2>&1')
         end
         puts "Running the load balancer"
	 system('docker run -d --net=host --name nginx puppet/nginx > /dev/null 2>&1')
       end
       def logs
	 directory_name = "#{Dir.pwd}/.log/"
	 Dir.mkdir(directory_name) unless File.exists?(directory_name)
	 STDOUT.reopen("#{Dir.pwd}/.log/cluster-build.log", "w")
         logger = Logger.new($stdout)
       end
	  def pre_checks
            boxes = ['puppetlabs/centos-7.2-64-puppet', 'puppetlabs/ubuntu-16.04-64-puppet']
            boxes.each do |box|
              dist = File.read("#{Dir.pwd}/servers.yaml")
              installed = dist.include?(box)
              if installed == true
                puts "#{box} is the current base image you are using"
                vagrant = system("vagrant box list | grep -ow #{box} > /dev/null 2>&1")
                if vagrant == true
                  puts "You have the base image already locally downloaded"
                else
                  puts "The base image needs to be downloaded.\nplease tail #{Dir.pwd}/.log/cluster-build.log for progress"
                end
	      end
            end
          end
	  if File.exist?("hieradata/etcd.yaml")
	    File.delete("hieradata/etcd.yaml")
	  end
	  File.open("hieradata/etcd.yaml", "w") { |file| file.write("kubernetes::etcd_initial_cluster: etcd-kube-master=http://172.17.10.101:2380,etcd-kube-replica-master-01=http://172.17.10.210:2380,etcd-kube-replica-master-02=http://172.17.10.220:2380") }
	  if OS.linux? == true
	    lb
	  elsif OS.mac? == true
            puts "Can not install the LB on Mac OS due to networking limitation on Docker for mac"
            puts "add '172.17.10.214 kubernetes' to /etc/hosts as a work around"
	    puts "Bringing up vagrant load balancer"
	    pidlb = fork do
	      logs
	      system("vagrant up lb")
	    end
	  end
	  puts "Deploying Kuberntetes HA controllers"
          puts "Checking for local Vagrant images"
          pre_checks
	  spinner = TTY::Spinner.new(":spinner Deploying the Kubernetes HA controller cluster...", format: :bouncing_ball)
	  spinner.auto_spin
	   pid1 = fork do
	    logs
	    system("vagrant up kube-master")
	  end
          pid2 = fork do
	    sleep 3
	    logs
	    system("vagrant up kube-replica-master-01")
          end
          pid3 = fork do
            sleep 5
	    logs
	    system("vagrant up kube-replica-master-02")
          end
	  Process.wait pid3
	  ex = $?.exitstatus
	  if ex =! 0
	    puts "Something went wrong ! see #{Dir.pwd}/.log/cluster-build.log for details"
	    exit 1
          end
	  spinner.stop('Kubernetes HA controller cluster is ready')
          puts "You can access your cluster with 'kubectl get nodes'"
        end
      kube_controller_ha
    end

desc "Set up local Kubectl"
task :kubectl do
     def post_checks
       puts "Checking if kubectl is installed"
       if File.exist?('/usr/local/bin/kubectl') or ('/usr/bin/kubectl') 
         puts "kubectl is installed"
       else
         puts "Kubectl is not installed, please install using the following"
	 puts "https://kubernetes.io/docs/tasks/tools/install-kubectl/"
       end
     end

     def kubectl
       directory_name = ".kube/"
       Dir.mkdir(directory_name) unless File.exists?(directory_name)
       if File.foreach("servers.yaml").grep(/ubuntu/).any?
         user = "vagrant"
       else
         user = "root"	       
       end
       system("vagrant ssh kube-master -c 'sudo cp /etc/kubernetes/admin.conf . && sudo chown vagrant:vagrant admin.conf > /dev/null 2>&1'")
       Net::SCP.download!("127.0.0.1", user,
	 "/home/vagrant/admin.conf", ".kube/",
         :ssh => { :port => 9999,:password => "vagrant" })
       puts "Configuring local Kubectl"
       puts "To use kubectl 'export KUBECONFIG=.kube/admin.conf' in your terminal"
     end
     post_checks
     kubectl
end

desc "Add's nodes to controllers after 'rake cluster_up_ha'"
task :add_nodes do 
      pid1 = fork do 
	system("vagrant up kube-node-01 > /dev/null 2>&1")
      end
      pid2 = fork do
        system("vagrant up kube-node-02 > /dev/null 2>&1")
      end
      puts "Depolying worker nodes"
      puts "To check the progress use 'kubectl get nodes'"
end

desc "Post tasks for cluster_up"
task :post_tasks do
	File.write(".kube/admin.conf",File.open(".kube/admin.conf",&:read).gsub("172.17.10.101:6443","kubernetes:6443"))
end

desc "Delete your Kubernetes cluster"
task :cleanup do
	system("vagrant	destroy -f > /dev/null 2>&1")
	puts "Deleting your Kuberntes cluster"
end

desc "Automate the full build of your Kubernetes cluster"
task :cluster_up => [
	:build,
	:kubectl,

]

desc "Automate the full build of your HA Kubernetes controllers"
task :cluster_up_ha => [
	:ha_controllers,
	:kubectl,
	:post_tasks, 
]

desc "Automate the full build of 3 controller and 2 nodes"
task :cluster_up_all => [
	:ha_controllers,
	:add_nodes,
	:kubectl,
	:post_tasks,
]	

