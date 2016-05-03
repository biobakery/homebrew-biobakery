class Kneaddata < Formula
  desc "KneadData"
  homepage "http://huttenhower.sph.harvard.edu/kneaddata"
  url "https://bitbucket.org/biobakery/kneaddata/downloads/kneaddata_v0.5.1.tar.gz"
  version "0.5.1"
  sha256 "ce70669d8b6bb0965cf3bc6977cac2fab7874e87e00bb0507eaed2cd51db3995"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/kneaddata*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install Dir[libexec/"bin/*.jar"]
  end

  test do
    system "#{bin}/kneaddata", "--help"
  end
end

