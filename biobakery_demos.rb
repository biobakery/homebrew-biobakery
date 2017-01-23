class BiobakeryDemos < Formula
  desc "BioBakery Demos: A collection of demos for the BioBakery Tool Suite"
  homepage "https://bitbucket.org/biobakery/biobakery/src/tip/demos/biobakery_demos"
  url "https://bitbucket.org/biobakery/biobakery/downloads/biobakery-v1.5.tar.gz"
  version "1.5"
  sha256 "dee260a9476749c9ef0ee2ad07cdd6970cece9e2d47de42708d6427daba5a9a7"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    cd "demos" do
      system "python2", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/biobakery_demos", "--help"
  end
end

