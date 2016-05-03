class Humann2 < Formula
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network 2"
  homepage "http://huttenhower.sph.harvard.edu/humann2"
  url "https://pypi.python.org/packages/source/h/humann2/humann2-0.7.0.tar.gz"
  version "0.7.0"
  sha256 "fab0438ac037a2843d2d7ffa74a8f113e3a299144c6cfdc4a100cc16eebed274"

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

