class BiobakeryToolSuite < Formula
  desc "BioBakery Tool Suite: A collection of tools for BioBakery"
  homepage "https://bitbucket.org/biobakery/biobakery/wiki/Home"
  url "https://bitbucket.org/biobakery/biobakery/get/92ba1f64a544.tar.gz"
  version "0.1.0-92ba1f64a544"
  sha256 "a8c2433ba84ffe0eae988b40f788a2b9ad7ce4fbfcedb4b4ce6445c072acc140"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  depends_on "biobakery/biobakery/humann2" => :recommended
  depends_on "biobakery/biobakery/kneaddata" => :recommended
  depends_on "biobakery/biobakery/picrust" => :recommended
  depends_on "biobakery/biobakery/maaslin" => :recommended
  depends_on "biobakery/biobakery/shortbred" => :recommended
  depends_on "biobakery/biobakery/sparsedossa" => :recommended
  depends_on "biobakery/biobakery/ppanini" => :recommended
  depends_on "biobakery/biobakery/lefse" => :recommended
  depends_on "biobakery/biobakery/graphlan" => :recommended
  depends_on "biobakery/biobakery/micropita" => :recommended
  depends_on "biobakery/biobakery/breadcrumbs" => :recommended
  depends_on "biobakery/biobakery/halla" => :recommended

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

