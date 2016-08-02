class Humann2 < Formula
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network 2"
  homepage "http://huttenhower.sph.harvard.edu/humann2"
  url "https://pypi.python.org/packages/9e/51/4bc4ecb0e8591588a933cd6db972012eb8d3c30e63666aec6abb7ab306e4/humann2-0.8.0.tar.gz"
  version "0.8.0"
  sha256 "21527527951cbedd772c4ca0316d36819ecf7f85444f752fcc11c0eac1213f03"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  # humann2 requires metaphlan2 as a dependency
  depends_on "biobakery/biobakery/metaphlan2" => :recommended

  def install
    # set PYTHONPATH to location where package will be installed (relative to homebrew location)
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    # run python setup.py install using recommended homebrew helper method with destination prefix of libexec
    system "python", *Language::Python.setup_install_args(libexec)
    # copy all of the installed scripts to the homebrew bin
    bin.install Dir[libexec/"bin/*"]
    # write stubs to bin that set PYTHONPATH and call executables, move executables back to original location
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/humann2", "--help"
  end
end

