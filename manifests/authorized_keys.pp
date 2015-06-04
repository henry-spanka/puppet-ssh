define ssh::authorized_keys::add_authorizedkey ($keys) {
    # This line allows default homedir based on $title variable.
    # If $home is empty, the default is used.
    $user = $title
    $userdir = $user ? {'root' => "/root", default => "/home/${user}" }
    
    user { $user:
	    ensure => present
    } ->
    file { "${userdir}/.ssh":
        ensure  => "directory",
        owner   => $title,
        group   => $title,
        mode    => 700
    } ->
    file { "${userdir}/.ssh/authorized_keys":
        owner   => $user,
        group   => $user,
        mode    => 600,
        content => template("${module_name}/authorized_keys.erb")
    }
}

class ssh::authorized_keys(
    $authorized_keys_hash
	)  {

    validate_hash($authorized_keys_hash)
    
    create_resources(ssh::authorized_keys::add_authorizedkey, $authorized_keys_hash)
}

