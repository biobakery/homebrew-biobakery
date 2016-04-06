class Graphlan < Formula
  desc "Graphlan"
  homepage "http://huttenhower.sph.harvard.edu/graphlan"
  url "https://bitbucket.org/nsegata/graphlan/downloads/graphlan_commit_d2ec14e.zip"
  version "0.9.7"
  sha256 "e00a9dc45c7b3055a52e5708eb5a114af88971e5ec2a814a9bd723e44971f4ac"

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

  resource "biopython" do
    url "http://biopython.org/DIST/biopython-1.66.tar.gz"
    sha256 "5178ea3b343b1d8710f39205386093e5369ed653aa020e1b0c4b7622a59346c1"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/source/p/pandas/pandas-0.13.1.tar.gz"
    sha256 "6813746caa796550969ed98069f16627f070f6d8d60686cfb3fa0e66c2e0312b"
  end

  resource "biom" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-2.0.1.tar.gz"
    sha256 "e2e8a843e7a85b6f48381e8b24b2e0809b111507efe7e1b86e8a63cb1b60a97c"
  end

  def install
    # add the install location of the libraries to the PYTHONPATH
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib64/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend "PYTHONPATH", libexec, ':'
    ENV.prepend "PYTHONPATH", libexec/"export2graphlan", ':'

    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?    
    # install dependencies
    for python_package in ["numpy","matplotlib","biopython", "pandas", "biom"]
        resource(python_package).stage do
            system "python", *Language::Python.setup_install_args(libexec)
        end
    end

    # copy the source to the library install location
    libexec.install Dir["*"]

    # copy the executable scripts to the bin folder
    bin.install libexec/"graphlan.py"
    bin.install libexec/"graphlan_annotate.py"
    bin.install libexec/"export2graphlan/export2graphlan.py"

    # create stubs of the scripts with the pythonpath added
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/graphlan.py", "--help"
  end
end

