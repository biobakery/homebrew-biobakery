class Kneaddata < Formula
  desc "KneadData"
  homepage "http://huttenhower.sph.harvard.edu/kneaddata"
  url "https://pypi.python.org/packages/6d/50/dd20a862b2532a476b4837a2b1fe4f9e8131cf554751adb6fd7186ee33e3/kneaddata-0.5.4.tar.gz"
  version "0.5.4"
  sha256 "c76940de21d3696a6113c51307322c0ff2eadebd62dc980a9923b49d963c26a3"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    system "python2", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/kneaddata*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install Dir[libexec/"bin/*.jar"]
  end

  test do
    system "#{bin}/kneaddata", "--help"
  end
end

