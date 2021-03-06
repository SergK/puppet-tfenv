# tfenv
[![Puppet Forge](http://img.shields.io/puppetforge/v/SergK/tfenv.svg)](https://forge.puppetlabs.com/SergK/tfenv) [![Github Tag](https://img.shields.io/github/tag/SergK/puppet-tfenv.svg)](https://github.com/SergK/puppet-tfenv) [![Build Status](https://travis-ci.org/SergK/puppet-tfenv.svg?branch=master)](https://travis-ci.org/SergK/puppet-tfenv) [![Coverage Status](https://coveralls.io/repos/github/SergK/puppet-tfenv/badge.svg?branch=master)](https://coveralls.io/github/SergK/puppet-tfenv?branch=master) [![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/SergK/tfenv.svg)](https://forge.puppetlabs.com/SergK/tfenv)

## Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with tfenv](#setup)
    * [What tfenv affects](#what-tfenv-affects)
    * [Beginning with tfenv](#beginning-with-tfenv)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs and configures [tfenv](https://github.com/kamatama41/tfenv)
tool which manages terraform version

## Module Description

The tfenv module sets up from the github repo tfenv utility which manages
terraform version. Module creates user and group `jenkins` by default.
This behavior can be changed.

## Setup

### What tfenv affects

By default:
* Clone and install tfenv into */opt/tfenv* folder;
* Create user *jenkins* and group *jenkins*


### Beginning with tfenv

```
include '::tfenv'
```

## Usage

All options and configuration can be done through interacting with the parameters
on the main ::tfenv class. The default parameters are defined in ::tfenv::params

### tfenv class

To start using tfenv one can use simple inclusion:

```
include '::tfenv'
```

If you don't need to create user you should define this explicitly, but please
ensure that both  user `tfenv_user` and group `tfenv_group` exists, otherwise
puppet run will fail:

```
class { '::tfenv':
  manage_user  => false,
  manage_group => false,
  tfenv_user   => root,
  tfenv_group  => root,
}
```

You can also provide custom installation directory as well as
[tfenv version](https://github.com/kamatama41/tfenv/releases):

```
class { '::tfenv':
  install_dir    => '/home/jenkins/tfenv',
  tfenv_revision => 'v0.5.1',
}
```

### tfenv::terraform

If you want to install several versions of terraform you can use
`tfenv::terraform`, e.g. install terraform versions '0.9.8', '0.9.9', '0.10.0':

```
include ::tfenv

$terraform_versions = ['0.9.8', '0.9.9', '0.10.0']

::tfenv::terraform { $terraform_versions: }

```

## Reference

## Classes

* tfenv - Main class for installation and configuration.
* tfenv::params - Different configuration data for module.

## Defined resource

* tfenv::terraform - install required version of terraform using tfenv tool

## Limitations

Tested and work on:
* CentOS 7
* Ubuntu 14.04
* Ubuntu 16.04
* Debian Jessie

## Development

Contributions will be gratefully accepted. All you pull requests should be done
in separate branch, e.g. `feature_abc`, `fix_version_issue`, etc.
