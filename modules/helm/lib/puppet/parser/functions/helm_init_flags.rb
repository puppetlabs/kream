require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm init flags
  newfunction(:helm_init_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['init']
      flags << 'init'
    end

    if opts['canary_image']
      flags << '--canary-image'
    end

    if opts['client_only']
      flags << '--client-only'
    end

    if opts['debug']
      flags << '--debug'
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

    if opts['local_repo_url'].to_s != 'undef'
      flags << "--local-repo-url '#{opts['local_repo_url']}'"
    end

    if opts['net_host']
      flags << '--net-host'
    end

    if opts['service_account'].to_s != 'undef'
      flags << "--service-account '#{opts['service_account']}'"
    end

    if opts['skip_refresh']
      flags << '--skip-refresh'
    end

    if opts['stable_repo_url'].to_s != 'undef'
      flags << "--stable-repo-url '#{opts['stable_repo_url']}'"
    end

    if opts['tiller_image'].to_s != 'undef'
      flags << "--tiller-image '#{opts['tiller_image']}'"
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if opts['tiller_tls']
      flags << '--tiller-tls'
    end

    if opts['tiller_tls_cert'].to_s != 'undef'
      flags << "--tiller-tls-cert '#{opts['tiller_tls_cert']}'"
    end

    if opts['tiller_tls_key'].to_s != 'undef'
      flags << "--tiller-tls-key '#{opts['tiller_tls_key']}'"
    end

    if opts['tiller_tls_verify']
      flags << '--tiller-tls-verify'
    end

    if opts['tls_ca_cert'].to_s != 'undef'
      flags << "--tls_ca_cert '#{opts['tls_ca_cert']}'"
    end

    if opts['upgrade']
      flags << '--upgrade'
    end

    flags.flatten.join(" ")
  end
end
