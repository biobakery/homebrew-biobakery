class BiobakeryDemos < Formula
  desc "BioBakery Demos: A collection of demos for the BioBakery Tool Suite"
  homepage "https://bitbucket.org/ljmciver/biobakery_demos/"
  url "https://bitbucket.org/ljmciver/biobakery_demos/get/0.0.1.tar.gz"
  version "0.1.0"
  sha256 "199b54761ec1fb49fe4e63e7f0fe6452d6eabe1814566e21b3622ee370fc49ed"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/biobakery_demos", "--help"
  end
end

