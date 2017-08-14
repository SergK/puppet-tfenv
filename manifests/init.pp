# == Class: tfenv
#
class tfenv(
  $default_terraform_version = undef,
  $install_dir               = $::tfenv::params::install_dir,
  $tfenv_git_repo            = $::tfenv::params::tfenv_git_repo,
  $tfenv_revision            = $::tfenv::params::tfenv_revision,
  $tfenv_user                = $::tfenv::params::tfenv_user,
  $tfenv_group               = $::tfenv::params::tfenv_group,
  Boolean $manage_user       = true,
  Boolean $manage_group      = true,
) inherits tfenv::params{

  $packages = [
    git,
    unzip
  ]

  ensure_packages($packages, {'ensure' => 'present'})

  if $manage_user {
    user { $tfenv_user:
      ensure  => present,
      comment => 'User to run tfenv',
      home    => $install_dir,
      shell   => '/usr/sbin/nologin',
      gid     => $tfenv_group,
      before  => File[$install_dir],
    }
  }
  if $manage_group {
    group { $tfenv_group:
      ensure => present,
      before => File[$install_dir],
    }
  }

  file { $install_dir:
    ensure  => directory,
    owner   => $tfenv_user,
    group   => $tfenv_group,
    mode    => '0755',
    require => Package[$packages],
  }
  -> vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    revision => $tfenv_revision,
    source   => $tfenv_git_repo,
    user     => $tfenv_user,
    group    => $tfenv_group,
  }

  file { '/usr/local/bin/tfenv':
    ensure  => link,
    target  => "${install_dir}/bin/tfenv",
    require => Vcsrepo[$install_dir],
  }

  file { '/usr/local/bin/terraform':
    ensure  => link,
    target  => "${install_dir}/bin/terraform",
    require => Vcsrepo[$install_dir],
  }

  if $default_terraform_version != undef {
    # Let's install and set default version for terraform
    ::tfenv::terraform { $default_terraform_version: }

    exec { "Set default terraform version to ${default_terraform_version}":
      command     => "tfenv use ${default_terraform_version}",
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless      => "grep ${default_terraform_version} ${install_dir}/version",
      refreshonly => true,
    }
  }
}
