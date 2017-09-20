require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm repo add flags
  newfunction(:helm_repo_add_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['ensure'].to_s == 'present'
      flags << 'add'
    end

    if opts['ca_file'].to_s != 'undef'
      flags << "--ca-file '#{opts['ca_file']}'"
    end

    if opts['cert_file'].to_s != 'undef'
      flags << "--cert-file '#{opts['cert_file']}'"
    end

    if opts['debug']
      flags << '--debug'
    end

    if opts['key_file'].to_s != 'undef'
      flags << "--repo-name '#{opts['key_file']}'"
    end

    if opts['no_update']
      flags << '--no-update'
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

    if opts['repo_name'].to_s != 'undef'
      flags << "'#{opts['repo_name']}'"
    end

    if opts['url'].to_s != 'undef'
      flags << "'#{opts['url']}'"
    end

    flags.flatten.join(" ")
  end
end






