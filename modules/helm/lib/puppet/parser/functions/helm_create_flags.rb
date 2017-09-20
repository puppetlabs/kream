require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm create flags
  newfunction(:helm_create_flags, :type => :rvalue) do |args|
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

    if opts['starter'].to_s != 'undef'
      flags << "--starter '#{opts['starter']}"
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if (opts['chart_path'].to_s != 'undef' && opts['chart_name'].to_s != 'undef')
      flags << "'#{opts['chart_path']}/#{opts['chart_name']}'"
    end

    flags.flatten.join(" ")
  end
end