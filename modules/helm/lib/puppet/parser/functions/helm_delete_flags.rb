require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm delete flags
  newfunction(:helm_delete_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['ensure'].to_s == 'absent'
      flags << "delete"
    end

    if opts['dry_run']
      flags << '--dry_run'
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

    if opts['no_hooks']
      flags << '--no-hooks'
    end

    if opts['purge']
      flags << '--purge'
    end

    if opts['timeout'].to_s != 'undef'
      flags << "--timeout '#{opts['timeout']}'"
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if opts['tls']
      flags << "--tls"
    end

    if opts['tls_ca_cert'].to_s != 'undef'
      flags << "--tls-ca-cert '#{opts['tls_ca_cert']}'"
    end

    if opts['tls_cert'].to_s != 'undef'
      flags << "--tls-cert '#{opts['tls_cert']}'"
    end

     if opts['tls_key'].to_s != 'undef'
      flags << "--tls-key '#{opts['tls_key']}'"
    end

    if opts['tls_verify']
      flags << '--tls-verify'
    end

    if opts['release_name'].to_s != 'undef'
      flags << "'#{opts['release_name']}'"
    end

   flags.flatten.join(" ")
  end
end
