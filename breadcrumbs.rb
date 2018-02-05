class Breadcrumbs < Formula
  desc "Miscellaneous Huttenhower Lab scripts"
  homepage "https://bitbucket.org/biobakery/breadcrumbs"
  url "https://bitbucket.org/biobakery/breadcrumbs/downloads/breadcrumbs-v0.92.tar.gz"
  version "0.92"
  sha256 "c03191eb5a5b51db2be63ef76030f8ffc52566d59254c983e63b46d0a520cab1"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
 
  # add the option to build with r 
  option "with-r", "Build with R support"
  depends_on "r" => [:optional, "without-x"]

  # mpi is required by mpi4py
  depends_on "mpich" => :recommended

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.7.1.tar.gz"
    sha256 "5525019a3085c3d860e6cfe4c0a30fb65d567626aafc50cf1252a641a418084a"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/source/s/scipy/scipy-0.12.0.tar.gz"
    sha256 "b967e802dafe2db043cfbdf0043e1312f9ce9c1386863e1c801a08ddfccf9de6"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "cogent" do
    url "https://github.com/pycogent/pycogent/archive/1.5.3-release.tar.gz"
    sha256 "4e19325cd1951382dc71582eb49f44c5a19eb128e3540e29dc28e080091e49cd"
  end

  resource "blist" do
    url "https://pypi.python.org/packages/source/b/blist/blist-1.3.6.tar.gz"
    sha256 "3a12c450b001bdf895b30ae818d4d6d3f1552096b8c995f0fe0c74bef04d1fc3"
  end

  resource "mpi4py" do
    url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-1.3.1.tar.gz"
    sha256 "e7bd2044aaac5a6ea87a87b2ecc73b310bb6efe5026031e33067ea3c2efc3507"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/94/51/3dd26b41be55ed05e72d1da87e4a732d8b92245b1f2f7fe2fa65a4910858/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  resource "cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end
  
  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib64/python2.7/site-packages"
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    # update CFLAGS for scipy install
    ENV.append "FFLAGS", "-fPIC" if OS.linux?
    %w[numpy scipy matplotlib biom-format pyqi blist cogent mpi4py pyparsing cycler dateutil].each do |r|
      resource(r).stage do
        system "python2", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "R_LIBS", libexec/"vendor/R/library"
    system "R", "-q", "-e", "install.packages('vegan', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
    system "R", "-q", "-e", "install.packages('r_optparse', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
    system "R", "-q", "-e", "install.packages('optparse', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
    system "R", "-q", "-e", "install.packages('ggplot2', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
    system "R", "-q", "-e", "install.packages('RColorBrewer', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
    system "R", "-q", "-e", "source('https://bioconductor.org/biocLite.R'); biocLite('EBImage', lib='" + libexec/"vendor/R/library" + "'); biocLite('ggtree', lib='" + libexec/"vendor/R/library" + "'); biocLite('Biostrings', lib='" + libexec/"vendor/R/library" + "');"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    args = Language::Python.setup_install_args(libexec)
    args[1].gsub! "setup.py", "actually_setup.py"
    system "python2", *args
    prefix.install Dir["*"]
    bin.install Dir["#{prefix}/breadcrumbs/scripts/*"]
    bin.env_script_all_files(prefix/"scripts", { :PYTHONPATH => ENV["PYTHONPATH"] , :R_LIBS => ENV["R_LIBS"] })
  end

  test do
    system "#{bin}/scriptPcoa.py", "--help"
  end
end
