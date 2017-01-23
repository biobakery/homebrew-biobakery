class BiobakeryToolSuite < Formula
  desc "BioBakery Tool Suite: A collection of tools for BioBakery"
  homepage "https://bitbucket.org/biobakery/biobakery/wiki/Home"
  url "https://bitbucket.org/biobakery/biobakery/downloads/biobakery-v1.5.tar.gz"
  version "1.5"
  sha256 "dee260a9476749c9ef0ee2ad07cdd6970cece9e2d47de42708d6427daba5a9a7"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  # install humann2 without metaphlan2 so we can next install metaphlan2_strainer (strainphlan)
  depends_on "biobakery/biobakery/humann2" => [:recommended, "without-metaphlan2"]
  depends_on "biobakery/biobakery/strainphlan" => :recommended
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
  depends_on "biobakery/biobakery/hclust2" => :recommended
  depends_on "biobakery/biobakery/panphlan" => :recommended

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

