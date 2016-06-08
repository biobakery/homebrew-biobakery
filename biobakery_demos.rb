class BiobakeryDemos < Formula
  desc "BioBakery Demos: A collection of demos for the BioBakery Tool Suite"
  homepage "https://bitbucket.org/biobakery/biobakery/src/tip/biobakery_demos"
  url "https://bitbucket.org/biobakery/biobakery/get/92ba1f64a544.tar.gz"
  version "0.1.0-92ba1f64a544"
  sha256 "a8c2433ba84ffe0eae988b40f788a2b9ad7ce4fbfcedb4b4ce6445c072acc140"

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

