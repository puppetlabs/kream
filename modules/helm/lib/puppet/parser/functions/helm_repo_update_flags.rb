require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm repo update flags
  newfunction(:helm_repo_update_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['debug']
      flags << '--debug'
    end

    if opts['home'].to_s != 'undef'
      flags << "--home '#{opts['home']}'"
    end

    if opts['host'].to_s != 'undef'
      flags << "--host '#{opts['host']}'"
    end

    if opts['kube_context'].to_s != 'undef'
      flags << "--kube-context '#{opts['kube_context']}'"
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if opts['update']
      flags << 'update'
    end

    flags.flatten.join(" ")
  end
end