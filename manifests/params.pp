# == Class: tfenv::params
#
class tfenv::params {
    $install_dir    = '/opt/tfenv'
    $tfenv_git_repo = 'https://github.com/kamatama41/tfenv'
    $tfenv_revision = 'v0.5.2'
    $tfenv_user     = 'jenkins'
    $tfenv_group    = 'jenkins'
}
