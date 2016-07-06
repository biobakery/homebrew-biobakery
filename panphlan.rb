class Panphlan < Formula
  desc "Panphlan"
  homepage "https://bitbucket.org/CibioCM/panphlan/overview"
  url "https://bitbucket.org/CibioCM/panphlan/get/77901ef96b97.tar.gz"
  version "1.2.1.3-77901ef"
  sha256 "4aae23bca9dd70ab27cc449c03314eddc9a796d9cfaa6c3b1b546eee8eb2289a"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on "homebrew/science/bowtie2" => [:recommended, "without-tbb"]
  depends_on "homebrew/science/samtools" => :recommended

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib64/python2.7/site-packages"
    
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    # install dependencies
    for python_package in ["numpy","biopython"]
        resource(python_package).stage do
            system "python", *Language::Python.setup_install_args(libexec/"vendor")
        end
    end

    bin.install Dir["*.py"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/panphlan_map.py", "--help"
  end
end

