<?php
    $lp = getenv('LANDING_PAGE');
    $node = getenv('NODE_APP');
?>

<VirtualHost *:80>
	ServerName demo.res.ch

	ProxyPass '/api/' 'http://<?php print "$node" ?>/'
	ProxyPassReverse '/api/' '<?php print "$node" ?>/'

	ProxyPass '/' 'http://<?php print "$lp" ?>/'
	ProxyPassReverse '/' 'http://<?php print "$lp" ?>/'
</VirtualHost>
