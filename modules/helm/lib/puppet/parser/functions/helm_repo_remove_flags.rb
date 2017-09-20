require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm repo remove flags
  newfunction(:helm_repo_remove_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['ensure'].to_s == 'absent'
      flags << 'remove'
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

    flags.flatten.join(" ")
  end
end