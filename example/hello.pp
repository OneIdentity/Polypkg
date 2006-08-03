# example package

%set
  name=hello
  version=1.0.0.0
  summary="Hello world"
  description="Engenders a global greeting"

%depend

%post
  echo This is the POST-INSTALL script

%preun
  echo This is the UNINSTALL script

%service hellod
  cmd=/usr/sbin/hellod

%files
  /usr/bin/hello
  /usr/bin/goodbye
  /usr/sbin/hellod
  /etc/hello.conf  644 volatile

%files dev
  /usr/bin/hello-config
