class Lefse < Formula
  desc "Lefse"
  homepage "http://huttenhower.sph.harvard.edu/lefse"
  url "https://bitbucket.org/nsegata/lefse/get/e3cabe93a0d1.tar.gz"
  version "1.0.0-dev-e3cabe93a0d1"
  sha256 "9d64aac0fdfd482639a4df21fdda921aace65ce23ad61afea624138a13cea8e2"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  # readline required by rpy2
  depends_on "readline" => :recommended

  # matplotlib on some platforms requires homebrew freetype
  depends_on "freetype" => :recommended

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "rpy2" do
    url "https://pypi.python.org/packages/source/r/rpy2/rpy2-2.7.8.tar.gz"
    sha256 "4f51bcdddea01a63e624f4b38de4f6b10a2466d82fd7e890791a07b06e51781d"
  end

  # singledispatch required by rpy2 but not installed by rpy2
  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
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
    # add the install location of the libraries to the PYTHONPATH
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib64/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?    
    # install dependencies
    for python_package in ["numpy","matplotlib","rpy2","singledispatch","pyparsing","cycler","dateutil"]
        resource(python_package).stage do
            system "python", *Language::Python.setup_install_args(libexec)
        end
    end

    # install the R packages
    ENV.prepend_create_path "R_LIBS", libexec/"R/library"
    for r_package in ['splines', 'stats4', 'survival','mvtnorm', 'modeltools', 'coin', 'MASS']
        system "R", "-q", "-e", "install.packages('" +  r_package + "', lib='" + libexec/"R/library" + "', repos='http://cran.r-project.org')"
    end

    # copy the source to the library install location
    libexec.install Dir["*"]

    # copy the executable scripts to the bin folder
    bin.install Dir[libexec/"*.py"]

    # create stubs of the scripts with the pythonpath added
    bin.env_script_all_files(libexec/"bin", {:PYTHONPATH => ENV["PYTHONPATH"], :R_LIBS => ENV["R_LIBS"]})
  end

  test do
    system "#{bin}/run_lefse.py", "--help"
  end
end

