#!/usr/bin/python -i

# Copyright (c)2010-2013 the Boeing Company.
# See the LICENSE file included in this distribution.

# connect n nodes to a virtual switch/hub

import sys, datetime, optparse

from core import pycore
from core.misc import ipaddr
from core.constants import *

# node list (count from 1)
n = [None]

def main():
    usagestr = "usage: %prog [-h] [options] [args]"
    parser = optparse.OptionParser(usage = usagestr)
    parser.set_defaults(numnodes = 5)

    parser.add_option("-n", "--numnodes", dest = "numnodes", type = int,
                      help = "number of nodes")

    def usage(msg = None, err = 0):
        sys.stdout.write("\n")
        if msg:
            sys.stdout.write(msg + "\n\n")
        parser.print_help()
        sys.exit(err)

    # parse command line options
    (options, args) = parser.parse_args()

    if options.numnodes < 1:
        usage("invalid number of nodes: %s" % options.numnodes)

    for a in args:
        sys.stderr.write("ignoring command line argument: '%s'\n" % a)

    start = datetime.datetime.now()

    # IP subnet
    prefix = ipaddr.IPv4Prefix("10.0.0.10/24")
    session = pycore.Session(persistent=True)
    if 'server' in globals():
        server.addsession(session)

    # Creates the internal Switch  
    switch = session.addobj(cls = pycore.nodes.SwitchNode, name = "InternalSwitch")
    switch.setposition(x=80,y=50)

    # Create Consul server
    server_services_str = "ConsulServer|NginxWSService"
    client_services_str = "ConsulClient|NginxWSService"
   
    for i in xrange(1, options.numnodes + 1):
        tmp = session.addobj(cls = pycore.nodes.CoreNode, name = "n%d" % i, objid=i)
        tmp.type = 'host'
        tmp.newnetif(switch, ["%s/%s" % (prefix.addr(i), prefix.prefixlen)])
        tmp.setposition(x=150*i,y=150)
        if i == 1:
            session.services.addservicestonode(tmp, "", server_services_str, verbose=False)
        else:
            session.services.addservicestonode(tmp, "", client_services_str, verbose=False)
        n.append(tmp)

    # Creates the LB
    lb_services_str = "ConsulClient|NginxLBService"
    tmp = session.addobj(cls = pycore.nodes.CoreNode, name = "LoadBalancer")
    tmp.type = 'host'
    tmp.newnetif(switch, ["%s/%s" % (prefix.addr(options.numnodes + 1), prefix.prefixlen)])
    tmp.setposition(x=150,y=350)        
    session.services.addservicestonode(tmp, "", lb_services_str, verbose=False)

    prefix = ipaddr.IPv4Prefix("10.0.1.10/24")
    switch = session.addobj(cls = pycore.nodes.SwitchNode, name = "ExternalSwitch")
    switch.setposition(x=150,y=450)
    tmp.newnetif(switch, ["%s/%s" % (prefix.addr(10), prefix.prefixlen)])

    for i in xrange(2, options.numnodes + 1):
        tmp = session.addobj(cls = pycore.nodes.CoreNode, name = "pc%d" % i)
        tmp.type = 'PC'
        tmp.newnetif(switch, ["%s/%s" % (prefix.addr(i + 10), prefix.prefixlen)])
        tmp.setposition(x=150*i,y=550)        
    
#    session.node_count = 1
    session.instantiate()
    # start a shell on node 1
    #n[1].term("bash")

    print "elapsed time: %s" % (datetime.datetime.now() - start)

if __name__ == "__main__" or __name__ == "__builtin__":
    main()
