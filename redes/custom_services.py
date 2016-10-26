''' Sample user-defined service.
'''

import os

from core.service import CoreService, addservice
from core.misc.ipaddr import IPv4Prefix, IPv6Prefix

class ConsulServerService(CoreService):
    ''' This is a sample user-defined service.
    '''
    # a unique name is required, without spaces
    _name = "ConsulServer"
    # you can create your own group here
    _group = "Utility"
    # list of other services this service depends on
    _depends = ()
    # per-node directories
    _dirs = ('/etc/consul.d', )
    # generated files (without a full path this file goes in the node's dir,
    #  e.g. /tmp/pycore.12345/n1.conf/)
    _configs = ('/etc/consul.d/web.json', 'consulstart.sh', )
    # this controls the starting order vs other enabled services
    _startindex = 50
    # list of startup commands, also may be generated during startup
    _startup = ('sh consulstart.sh', )
    # list of shutdown commands
    _shutdown = ()

    @classmethod
    def generateconfig(cls, node, filename, services):
        ipv4 = ''
        ipv6 = ''
        for ifc in node.netifs():
            for addr in ifc.addrlist:
                if addr.find(":") >= 0:
                    ipv6 = addr
                else:
                    ipv4 = addr.split('/')[0]

        if filename == "consulstart.sh":
            return """\
consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -bind=%s -config-dir /etc/consul.d
""" % (ipv4)
        else:
            return """\
{"service": {"name": "web", "tags": ["nginx"], "port": 80,
"check": {"script": "curl localhost >/dev/null 2>&1", "interval": "1s"}}}
"""
# this line is required to add the above class to the list of available services
addservice(ConsulServerService)

class ConsulClientService(CoreService):
    ''' This is a sample user-defined service.
    '''
    # a unique name is required, without spaces
    _name = "ConsulClient"
    # you can create your own group here
    _group = "Utility"
    # list of other services this service depends on
    _depends = ()
    # per-node directories
    _dirs = ('/etc/consul.d', )
    # generated files (without a full path this file goes in the node's dir,
    #  e.g. /tmp/pycore.12345/n1.conf/)
    _configs = ('/etc/consul.d/web.json', 'consulstart.sh', )
    # this controls the starting order vs other enabled services
    _startindex = 50
    # list of startup commands, also may be generated during startup
    _startup = ('sh consulstart.sh', )
    # list of shutdown commands
    _shutdown = ()

    @classmethod
    def generateconfig(cls, node, filename, services):
        ipv4 = ''
        ipv6 = ''
        for ifc in node.netifs():
            for addr in ifc.addrlist:
                if addr.find(":") >= 0:
                    ipv6 = addr
                else:
                    ipv4 = addr.split('/')[0]

        if filename == "consulstart.sh":
            return """\
consul agent -data-dir /tmp/consul -bind=%s -config-dir /etc/consul.d
""" % (ipv4)
        else:
            return """\
{"service": {"name": "web", "tags": ["nginx"], "port": 80,
"check": {"script": "curl localhost >/dev/null 2>&1", "interval": "1s"}}}
"""
addservice(ConsulClientService)

# nginx WS
class NginxWSService(CoreService):
    ''' This is a sample user-defined service.
    '''
    # a unique name is required, without spaces
    _name = "NginxWSService"
    # you can create your own group here
    _group = "Utility"
    # list of other services this service depends on
    _depends = ()
    # per-node directories
    _dirs = ('/etc/nginx', '/var/log/nginx', )
    # generated files (without a full path this file goes in the node's dir,
    #  e.g. /tmp/pycore.12345/n1.conf/)
    _configs = ('/etc/nginx/nginx.conf', '/etc/nginx/mime.types', '/etc/nginx/default', '/etc/nginx/index.html', 'startnginx.sh', )
    # this controls the starting order vs other enabled services
    _startindex = 50
    # list of startup commands, also may be generated during startup
    _startup = ('sh startnginx.sh', )
    # list of shutdown commands
    _shutdown = ()

    @classmethod
    def generateconfig(cls, node, filename, services):
        ipv4 = ''
        ipv6 = ''
        for ifc in node.netifs():
            for addr in ifc.addrlist:
                if addr.find(":") >= 0:
                    ipv6 = addr
                else:
                    ipv4 = addr.split('/')[0]

        if filename == "/etc/nginx/nginx.conf":
            return """\
user www-data;
worker_processes 4;
pid /run/nginx.pid;

events {
	worker_connections 768;
}

http {
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;
	gzip on;
	gzip_disable "msie6";

	include /etc/nginx/default;
}
"""
        elif filename == "/etc/nginx/mime.types":
            return """\
types {
	text/html				html htm shtml;
	text/css				css;
	text/xml				xml rss;
	image/gif				gif;
	image/jpeg				jpeg jpg;
	application/x-javascript		js;
	application/atom+xml			atom;

	text/mathml				mml;
	text/plain				txt;
	text/vnd.sun.j2me.app-descriptor	jad;
	text/vnd.wap.wml			wml;
	text/x-component			htc;

	image/png				png;
	image/tiff				tif tiff;
	image/vnd.wap.wbmp			wbmp;
	image/x-icon				ico;
	image/x-jng				jng;
	image/x-ms-bmp				bmp;
	image/svg+xml				svg svgz;

	application/java-archive		jar war ear;
	application/json			json;
	application/mac-binhex40		hqx;
	application/msword			doc;
	application/pdf				pdf;
	application/postscript			ps eps ai;
	application/rtf				rtf;
	application/vnd.ms-excel		xls;
	application/vnd.ms-powerpoint		ppt;
	application/vnd.wap.wmlc		wmlc;
	application/vnd.google-earth.kml+xml	kml;
	application/vnd.google-earth.kmz	kmz;
	application/x-7z-compressed		7z;
	application/x-cocoa			cco;
	application/x-java-archive-diff		jardiff;
	application/x-java-jnlp-file		jnlp;
	application/x-makeself			run;
	application/x-perl			pl pm;
	application/x-pilot			prc pdb;
	application/x-rar-compressed		rar;
	application/x-redhat-package-manager	rpm;
	application/x-sea			sea;
	application/x-shockwave-flash		swf;
	application/x-stuffit			sit;
	application/x-tcl			tcl tk;
	application/x-x509-ca-cert		der pem crt;
	application/x-xpinstall			xpi;
	application/xhtml+xml			xhtml;
	application/zip				zip;

	application/octet-stream		bin exe dll;
	application/octet-stream		deb;
	application/octet-stream		dmg;
	application/octet-stream		eot;
	application/octet-stream		iso img;
	application/octet-stream		msi msp msm;
	application/ogg				ogx;

	audio/midi				mid midi kar;
	audio/mpeg				mpga mpega mp2 mp3 m4a;
	audio/ogg				oga ogg spx;
	audio/x-realaudio			ra;
	audio/webm				weba;

	video/3gpp				3gpp 3gp;
	video/mp4				mp4;
	video/mpeg				mpeg mpg mpe;
	video/ogg				ogv;
	video/quicktime				mov;
	video/webm				webm;
	video/x-flv				flv;
	video/x-mng				mng;
	video/x-ms-asf				asx asf;
	video/x-ms-wmv				wmv;
	video/x-msvideo				avi;
}
"""
        elif filename == "/etc/nginx/default":
            return """\
server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

	root /etc/nginx;
	index index.html index.htm;
	server_name localhost;

	location / {
		try_files $uri $uri/ =404;
	}
}
"""
        elif filename == "startnginx.sh":
            return "nginx"
        elif filename == "/etc/nginx/index.html":
            return """\
<!DOCTYPE html>
<html>
<head>
<title>Welcome</title>
</head>
<body>
<h1>Welcome to %s!</h1>
<p><em>Thank you for using nginx.</em></p>
</body>
</html>
""" % (node.name)

addservice(NginxWSService)
# nginx WS
class NginxLBService(CoreService):
    ''' This is a sample user-defined service.
    '''
    # a unique name is required, without spaces
    _name = "NginxLBService"
    # you can create your own group here
    _group = "Utility"
    # list of other services this service depends on
    _depends = ()
    # per-node directories
    _dirs = ('/etc/nginx', '/var/log/nginx', )
    # generated files (without a full path this file goes in the node's dir,
    #  e.g. /tmp/pycore.12345/n1.conf/)
    _configs = ('/etc/nginx/nginx.conf', '/etc/nginx/mime.types', 'service.ctmpl', 'startnginx.sh', )
    # this controls the starting order vs other enabled services
    _startindex = 50
    # list of startup commands, also may be generated during startup
    _startup = ('sh startnginx.sh', )
    # list of shutdown commands
    _shutdown = ()

    @classmethod
    def generateconfig(cls, node, filename, services):
        ipv4 = ''
        ipv6 = ''
        for ifc in node.netifs():
            for addr in ifc.addrlist:
                if addr.find(":") >= 0:
                    ipv6 = addr
                else:
                    ipv4 = addr.split('/')[0]

        if filename == "/etc/nginx/nginx.conf":
            return """\
user www-data;
worker_processes 4;
pid /run/nginx.pid;

events {
	worker_connections 768;
}

http {

    log_format timed_combined '$upstream_response_time';
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	access_log /var/log/nginx/access.log timed_combined;
	error_log /var/log/nginx/error.log;
	gzip on;
	gzip_disable "msie6";

	include /etc/nginx/*.template;
}
"""
        elif filename == "/etc/nginx/mime.types":
            return """\
types {
	text/html				html htm shtml;
	text/css				css;
	text/xml				xml rss;
	image/gif				gif;
	image/jpeg				jpeg jpg;
	application/x-javascript		js;
	application/atom+xml			atom;

	text/mathml				mml;
	text/plain				txt;
	text/vnd.sun.j2me.app-descriptor	jad;
	text/vnd.wap.wml			wml;
	text/x-component			htc;

	image/png				png;
	image/tiff				tif tiff;
	image/vnd.wap.wbmp			wbmp;
	image/x-icon				ico;
	image/x-jng				jng;
	image/x-ms-bmp				bmp;
	image/svg+xml				svg svgz;

	application/java-archive		jar war ear;
	application/json			json;
	application/mac-binhex40		hqx;
	application/msword			doc;
	application/pdf				pdf;
	application/postscript			ps eps ai;
	application/rtf				rtf;
	application/vnd.ms-excel		xls;
	application/vnd.ms-powerpoint		ppt;
	application/vnd.wap.wmlc		wmlc;
	application/vnd.google-earth.kml+xml	kml;
	application/vnd.google-earth.kmz	kmz;
	application/x-7z-compressed		7z;
	application/x-cocoa			cco;
	application/x-java-archive-diff		jardiff;
	application/x-java-jnlp-file		jnlp;
	application/x-makeself			run;
	application/x-perl			pl pm;
	application/x-pilot			prc pdb;
	application/x-rar-compressed		rar;
	application/x-redhat-package-manager	rpm;
	application/x-sea			sea;
	application/x-shockwave-flash		swf;
	application/x-stuffit			sit;
	application/x-tcl			tcl tk;
	application/x-x509-ca-cert		der pem crt;
	application/x-xpinstall			xpi;
	application/xhtml+xml			xhtml;
	application/zip				zip;

	application/octet-stream		bin exe dll;
	application/octet-stream		deb;
	application/octet-stream		dmg;
	application/octet-stream		eot;
	application/octet-stream		iso img;
	application/octet-stream		msi msp msm;
	application/ogg				ogx;

	audio/midi				mid midi kar;
	audio/mpeg				mpga mpega mp2 mp3 m4a;
	audio/ogg				oga ogg spx;
	audio/x-realaudio			ra;
	audio/webm				weba;

	video/3gpp				3gpp 3gp;
	video/mp4				mp4;
	video/mpeg				mpeg mpg mpe;
	video/ogg				ogv;
	video/quicktime				mov;
	video/webm				webm;
	video/x-flv				flv;
	video/x-mng				mng;
	video/x-ms-asf				asx asf;
	video/x-ms-wmv				wmv;
	video/x-msvideo				avi;
}
"""
        elif filename == "service.ctmpl":
            return """\
upstream myapp1 {
	    least_conn;
        {{range service "web"}}server {{.Address}}:{{.Port}} max_fails=0 fail_timeout=0 weight=1;
        {{else}}server 127.0.0.1:65535; # force a 502{{end}}
    }

    server {
        listen 80;

        location / {
            proxy_pass http://myapp1;
        }
    }
"""
        elif filename == "startnginx.sh":
            return """\
nginx
consul-template -consul=127.0.0.1:8500 -template="service.ctmpl:/etc/nginx/service.template:service nginx reload"
            """

addservice(NginxLBService)
