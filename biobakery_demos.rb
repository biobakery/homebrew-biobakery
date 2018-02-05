class BiobakeryDemos < Formula
  desc "BioBakery Demos: A collection of demos for the BioBakery Tool Suite"
  homepage "https://bitbucket.org/biobakery/biobakery/src/tip/demos/biobakery_demos"
  url "https://bitbucket.org/biobakery/biobakery/downloads/biobakery-v1.6.tar.gz"
  version "1.6"
  sha256 "22d625b8ad5815ee9c777ecd504da6e6d9eee7b72b1547c37f98cf2e5c67b28c"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard

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

