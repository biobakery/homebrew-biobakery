To get started, install [HomeBrew](http://brew.sh/) for MacOS or [LinuxBrew](http://linuxbrew.sh/) for Linux platforms.

* If you are running MacOS
    * `` $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ``
* If you are running Linux (the ``brew`` command is the same but the HomeBrew package manager is called [LinuxBrew](http://linuxbrew.sh/) )
    * `` $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)" ``
    * Add the following lines to your ``$HOME/.bashrc`` file:
        * `` export PATH="$HOME/.linuxbrew/bin:$PATH" ``
        * `` export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH" ``
        * `` export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH" ``
    * Source the file so the changes take effect for this session.
        * `` $ source $HOME/.bashrc ``
        * These changes will automatically be applied each time you start a new session. There is no need to source the file in future sessions.
