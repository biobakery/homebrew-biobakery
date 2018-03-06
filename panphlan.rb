class Panphlan < Formula
  desc "Panphlan"
  homepage "https://bitbucket.org/CibioCM/panphlan/overview"
  url "https://bitbucket.org/CibioCM/panphlan/get/a25bc29ad4ec.tar.gz"
  version "1.2.1.3-a25bc29"
  sha256 "dbeb7b726df7bdf930e865e693493d18282f22e2d416a39ba37389a30986184a"

  # add the python dependencies and options
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
  option "with-python3", "Build with python3 instead of python2"
  depends_on "python3" => :optional

  depends_on "homebrew/core/bowtie2" => [:recommended, "without-tbb"]
  depends_on "homebrew/core/samtools" => :recommended

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  def get_python_version
    # check the python version to install with
    if build.with? "python3"
        python="python3"
    else
        python="python2"
    end

    # get the full python version selected
    python_full_version = `#{python} --version 2>&1`

    # return an error if the python version selected is not installed
    unless $?.exitstatus == 0
     abort("Please install #{python}")
    end

    # get the major/minor python version to determine
    # the install folder location
    python_version = python_full_version.split(" ")[1].split(".").first(2).join(".")

    return [python, python_version]
  end

  def install
    # get the python executable and version
    python, python_version = get_python_version

    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib/python#{python_version}/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib64/python#{python_version}/site-packages"
    
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    # install dependencies
    for python_package in ["numpy","biopython"]
        resource(python_package).stage do
            system python, *Language::Python.setup_install_args(libexec/"vendor")
        end
    end

    # if using python3, modify the scripts (by default it uses python2)
    # to use the latest python3 installed since they are executed directly
    if build.with? "python3"
      Dir["*.py"].each do |script|
          system "sed -i '1 s/python/python3/' #{script}"
      end
    end

    bin.install Dir["*.py"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/panphlan_map.py", "--help"
  end
end

