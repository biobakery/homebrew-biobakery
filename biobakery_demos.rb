class BiobakeryDemos < Formula
  desc "BioBakery Demos: A collection of demos for the BioBakery Tool Suite"
  homepage "https://bitbucket.org/biobakery/biobakery/src/tip/demos/biobakery_demos"
  url "https://bitbucket.org/biobakery/biobakery/downloads/biobakery-v1.3.tar.gz"
  version "1.3"
  sha256 "889f33139b2b8eeff69617237c815677c96843fc35d248f4068633a4289bcefb"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    cd "demos" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/biobakery_demos", "--help"
  end
end

