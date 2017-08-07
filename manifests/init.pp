# == Class: tfenv
#
class tfenv(
  $install_dir    = $::tfenv::params::install_dir,
  $tfenv_git_repo = $::tfenv::params::tfenv_git_repo,
  $tfenv_revision = $::tfenv::params::tfenv_revision,
  $tfenv_user     = $::tfenv::params::tfenv_user,
  $tfenv_group    = $::tfenv::params::tfenv_group,
  $manage_user    = true,
) inherits tfenv::params{

  $packages = [
    git,
  ]

  package { $packages:
    ensure => latest,
  }

  if $manage_user == true {
    group { $tfenv_group:
      ensure => 'present',
      gid    => '1010',
    }

    user { $tfenv_user:
      ensure  => present,
      comment => 'User to run cloudwatch_importer',
      home    => $install_dir,
      shell   => '/usr/sbin/nologin',
      uid     => '1010',
      gid     => $tfenv_group,
      require => Group[$tfenv_group],
    }
  }

  file { $install_dir:
    ensure  => directory,
    owner   => $tfenv_user,
    group   => $tfenv_group,
    mode    => '0755',
    require => [
      User[$tfenv_user],
      Package[$packages],
    ],
  }
  -> vcsrepo { $install_dir:
    ensure   => latest,
    provider => 'git',
    revision => $tfenv_revision,
    source   => $tfenv_git_repo,
    user     => $tfenv_user,
    group    => $tfenv_group,
  }

}
