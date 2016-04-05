class Shortbred < Formula
  desc "ShortBRED: Short, Better Representative Extract Dataset"
  homepage "https://huttenhower.sph.harvard.edu/shortbred"
  url "https://bitbucket.org/biobakery/shortbred/get/tip.zip"
  version "0.9.3"
  sha256 "c7c42db5f8133c32475476325f3155ce21724b0e7bf42a099ba32189b9b2b995"

  # NOTE: blast install results in error for gcc 5x (to install without blast add --without-blast)
  depends_on "homebrew/science/blast" => :recommended
  depends_on "homebrew/science/muscle"  
  depends_on "homebrew/science/cd-hit"  

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  def install
    # add the install location of the libraries to the PYTHONPATH
    ENV.prepend_create_path "PYTHONPATH", libexec
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib64/python2.7/site-packages"

    # install dependencies
    for python_package in ["biopython"]
        resource(python_package).stage do
            system "python", *Language::Python.setup_install_args(libexec)
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

