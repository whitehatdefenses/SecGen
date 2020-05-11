class iceweasel::config {
  $secgen_params = secgen_functions::get_parameters($::base64_inputs_file)
  $accounts = $secgen_params['accounts']
  $autostart = str2bool($secgen_params['autostart'][0])
  $start_page = $secgen_params['start_page'][0]
  $disable_proxy = str2bool($secgen_params['disable_proxy'][0])

  # Setup IW for each user account
  $accounts.each |$raw_account| {
    $account = parsejson($raw_account)
    $username = $account['username']
    # set home directory
    if $username == 'root' {
      $home_dir = "/root"
    } else {
      $home_dir = "/home/$username"
    }

    # add user profile
    file { ["$home_dir/", "$home_dir/.mozilla/",
      "$home_dir/.mozilla/firefox",
      "$home_dir/.mozilla/firefox/user.default"]:
      ensure => directory,
      owner  => $username,
      group  => $username,
    }->
    file { "$home_dir/.mozilla/firefox/profiles.ini":
      ensure => file,
      source => 'puppet:///modules/iceweasel/profiles.ini',
      owner  => $username,
      group  => $username,
    }->
    file { "$home_dir/.mozilla/firefox/installs.ini":
      ensure => file,
      source => 'puppet:///modules/iceweasel/installs.ini',
      owner  => $username,
      group  => $username,
    }->

    # set start page via template:
    file { "$home_dir/.mozilla/firefox/user.default/user.js":
      ensure => file,
      content => template('iceweasel/user.js.erb'),
      owner  => $username,
      group  => $username,
    }

    # autostart script
    if $autostart {
      file { ["$home_dir/.config/", "$home_dir/.config/autostart/"]:
        ensure => directory,
        owner  => $username,
        group  => $username,
        require => File["$home_dir/"],
      }

      file { "$home_dir/.config/autostart/iceweasel.desktop":
        ensure => file,
        source => 'puppet:///modules/iceweasel/iceweasel.desktop',
        owner  => $username,
        group  => $username,
      }
    }
  }
}
