class Lefse < Formula
  desc "Lefse"
  homepage "http://huttenhower.sph.harvard.edu/lefse"
  url "https://bitbucket.org/nsegata/lefse/get/e3cabe93a0d1.tar.gz"
  version "1.0.0-dev-e3cabe93a0d1"
  sha256 "9d64aac0fdfd482639a4df21fdda921aace65ce23ad61afea624138a13cea8e2"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

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

  def install
    # add the install location of the libraries to the PYTHONPATH
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib64/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?    
    # install dependencies
    for python_package in ["numpy","matplotlib","rpy2", "singledispatch"]
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

