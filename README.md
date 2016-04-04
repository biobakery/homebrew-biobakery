# homebrew-biobakery
Biobakery formulae for the Homebrew package manager.

To get started, install [HomeBrew](http://brew.sh/) for MacOS or [LinuxBrew](http://linuxbrew.sh/) for Linux platforms.

Next install the main biobakery tool dependencies, if they are not already installed:

1. [Python v2.7.3+](https://www.python.org/)
    * Check if installed: `` $ python --version ``
    * To install: `` $ brew install python ``
2. [R](https://www.r-project.org/about.html)
    * Check if installed: `` $ R --version ``
    * To install: `` $ brew install homebrew/science/r ``

Now to install biobakery tools with HomeBrew, first tap the biobakery homebrew repository:

`` $ brew tap biobakery/biobakery ``

Then install the biobakery tools:

1. HUMAnN2
    * `` $ brew install humann2 ``
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

