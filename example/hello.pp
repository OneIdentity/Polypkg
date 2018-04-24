# example package

%set
  name=hello
  version=1.0.0.1
  summary="Hello world"
  description="Engenders a global greeting"

%set [bsd]
  pp_bsd_name="${name}"
# For a single message use pp_bsd_message
#   pp_bsd_message="message"
# For multiple messages use pp_bsd_message[1..n]
#   pp_bsd_messages1="message 1"
#   pp_bsd_messages2="message 2"
#   pp_bsd_messages[3..n]="message [3..n]
#
# In the case where both pp_bsd_message and pp_bsd_messages[1..n] are supplied treat pp_bsd_message as pp_bsd_messages0
  pp_bsd_message="Greetings from hello world!"
  pp_bsd_messages_1="2nd Message"
  pp_bsd_messages_2="3rd Message"

  pp_bsd_origin="security/${pp_bsd_name:-$name}"
  # In this example pp_bsd_prefix should always match the Makefile $prefix value
  pp_bsd_prefix="${prefix}"
  pp_bsd_www="https://www.oneidentity.com"
  pp_bsd_maintainer="One Identity LLC <support@oneidentity.com>"

  # pp_bsd_licenses need to be in array formating, each value seperated by a ,
  # i.e. [ value, value ]
  pp_bsd_licenses="[GPLv2,MIT]"

  # pp_bsd_annotations need to be in a keyvalue:pair list, each key:pair being seperated by a ,
  # i.e. key:value, key:value 
  pp_bsd_annotations="repo_type:binary, hello:world"

  # pp_bsd_categories need to be in array formating, each value seperated by a ,
  # i.e. [ value, value ]
  pp_bsd_categories="[devel,security]"
 
  pp_bsd_abi="FreeBSD:*:amd64"
  pp_bsd_svc_init_filename="hellod"
  pp_bsd_svc_init_filepath="${pp_bsd_prefix}/etc/rc.d"

%depend dev [bsd]
  grep
  hello hello 1.0.0.1

%pre
  echo This is the PRE-INSTALL script

%post [bsd]
  name=%{pp_bsd_svc_init_filename}
  echo This is the POST-INSTALL script
  %(pp_functions pp_mkuser)

  if [ -x "%{pp_bsd_svc_init_filepath}/${name}" ]; then
        service /${name} status > /dev/null 2>&1
        RUNNING=$?
        if [ $RUNNING -eq 0 ]; then
            service /${name} restart
        else
            service /${name} start
        fi
    sleep 2
    echo "Done"
  fi

%preun [bsd]
  name=%{pp_bsd_svc_init_filename}
  echo This is the PRE-UNINSTALL script
  if [ -x "%{pp_bsd_svc_init_filepath}/${name}" ]; then
    service /${name} status > /dev/null 2>&1
    RUNNING=$?
    if [ $RUNNING -eq 0 ]; then
        service /${name} stop
    fi
  fi

%postun
  echo This is the POST-UNINSTALL script

%preup [bsd]
  echo This is the PRE-UPGRADE script
%postup [bsd]
  echo This is the POST-UPRADE script

%files
  ${bindir}/
  ${sbindir}/
  ${sysconfdir}/
  ${libdir}/
  ${bindir}/hello
  ${bindir}/goodbye
  ${sbindir}/hellod
  ${sysconfdir}/hello.conf  644 volatile
  ${libdir}/hello/
  ${libdir}/slink

%service hellod
  cmd=$sbindir/hellod
  pidfile="/var/run/${pp_bsd_svc_init_filename}.pid"
  pp_bsd_svc_pre_command="/usr/sbin/daemon"
  pp_bsd_svc_pre_command_args="-f \${${pp_bsd_svc_init_filename}_pidfile:+\"-P \$${pp_bsd_svc_init_filename}_pidfile\"}"

%files dev
  ${bindir}/
  ${bindir}/hello-config

%fixup
  echo This is the FIXUP script
