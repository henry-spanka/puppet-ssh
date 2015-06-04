define ssh::private_keys::add_key(
    $name,
    $user,
    $privpath = false,
    $pubpath = false
) {
    
    $userdir = $user ? {'root' => "/root", default => "/home/${user}" }
    
    if (is_string($privpath)) {
    
        file {
            "${user}-${title}-priv":
                ensure => present,
                owner => $user,
                group => $user,
                mode => 600,
                path => "${userdir}/.ssh/${name}",
                source => "puppet:///modules/${module_name}/keys/${privpath}"
        }
    }
    if (is_string($pubpath)) {
        file {
            "${user}${title}-pub":
                ensure => present,
                owner => $user,
                group => $user,
                mode => 600,
                path => "${userdir}/.ssh/${name}.pub",
                source => "puppet:///modules/${module_name}/keys/${pubpath}"
        }
    }
}

class ssh::private_keys(
    $private_keys_hash
	) {

    validate_hash($private_keys_hash)
    
    create_resources(ssh::private_keys::add_key, $private_keys_hash)
  
}
