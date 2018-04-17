class Shortbred < Formula
  desc "ShortBRED: Short, Better Representative Extract Dataset"
  homepage "https://huttenhower.sph.harvard.edu/shortbred"
  url "https://bitbucket.org/biobakery/shortbred/get/702e3ef41be4.tar.gz"
  version "0.9.3-dev-702e3ef"
  sha256 "9cbe4dc1cc3b3e7c525aef400a52e0c58aae663f249dd1b72c2a6f2900ac48e4"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard

  depends_on "biobakery/biobakery/blast" => :recommended
  depends_on "brewsci/bio/muscle" => :recommended
  depends_on "brewsci/science/cd-hit" => :recommended

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  def install
    # add the install location of the libraries to the PYTHONPATH
    ENV.prepend_create_path "PYTHONPATH", libexec
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib64/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    # install dependencies
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    for python_package in ["numpy","matplotlib","biopython"]
        resource(python_package).stage do
            system "python2", *Language::Python.setup_install_args(libexec)
        end
    end

    # copy the source to the library install location
    libexec.install Dir["*"]

    # copy the executable scripts to the bin folder
    bin.install Dir[libexec/"*.py"]

    # create stubs of the scripts with the pythonpath added
    bin.env_script_all_files(libexec, :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/shortbred_quantify.py", "--help"
  end
end

