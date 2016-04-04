# homebrew-biobakery
Biobakery formulae for the Homebrew package manager.

To get started, install [HomeBrew](http://brew.sh/):

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

Next install the main biobakery tool dependencies:

1. [Python v2.7.3+](https://www.python.org/)
    * `` $ brew install python ``
    * The python install includes pip.
2. [R](https://www.r-project.org/about.html)
    * `` $ brew install homebrew/science/r ``

Now to install biobakery tools with HomeBrew, first tap the biobakery homebrew repository:

`` $ brew tap biobakery/biobakery ``

Next install the biobakery tools:

1. HUMAnN2
    * `` $ brew install humann2 ``
    * OR `` $ pip install humann2 ``
    * Demo databases are included with the install. To install the full databases, see the humann2 documentation: http://huttenhower.sph.harvard.edu/humann2
2. KneadData
    * `` $ brew install kneaddata ``
    * Demo databases are included with the install. To install the full databases, see the kneaddata documentation: http://huttenhower.sph.harvard.edu/kneaddata
3. Picrust
    * Install numpy: `` $ pip install numpy==1.5.1 ``
    * Install BIOM: `` $ pip install biom-format==1.3.1 ``
    * `` $ brew install picrust ``
4. Maaslin
    * `` $ brew install maaslin ``
5. Graphlan
    * TDB
6. Metaphlan2
    * TDB
7. Lefse
    * TDB
8. Micropita
    * TDB

