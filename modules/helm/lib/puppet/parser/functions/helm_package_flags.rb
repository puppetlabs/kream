require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm package flags
  newfunction(:helm_package_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['debug']
      flags << '--debug'
    end

    if opts['dependency_update']
      flags << '--dependency-update'
    end

    if opts['destination'].to_s != 'undef'
      flags << "--destination '#{opts['destination']}'"
    end

    if opts['home'].to_s != 'undef'
      flags << "--home '#{opts['home']}'"
    end

    if opts['host'].to_s != 'undef'
      flags << "--host '#{opts['host']}'"
    end

    if opts['key'].to_s != 'undef'
      flags << "--key '#{opts['key']}'"
    end

    if opts['keystring'].to_s != 'undef'
      flags << "--keystring '#{opts['keystrings']}'"
    end

    if opts['kube_context'].to_s != 'undef'
      flags << "--kube-context '#{opts['kube_context']}'"
    end

    if opts['save']
      flags << '--save'
    end

    if opts['sign']
      flags << '--sign'
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if opts['version'].to_s != 'undef'
      flags << "--version '#{opts['version']}'"
    end

    if (opts['chart_path'].to_s != 'undef' && opts['chart_name'].to_s != 'undef')
      flags << "'#{opts['chart_path']}/#{opts['chart_name']}'"
    end

    flags.flatten.join(" ")
  end
end
