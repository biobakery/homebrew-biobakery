class BiobakeryToolSuite < Formula
  desc "BioBakery Tool Suite: A collection of tools for BioBakery"
  homepage "https://bitbucket.org/biobakery/biobakery/wiki/Home"
  url "https://bitbucket.org/biobakery/biobakery/downloads/biobakery-v1.6.tar.gz"
  version "1.6"
  sha256 "22d625b8ad5815ee9c777ecd504da6e6d9eee7b72b1547c37f98cf2e5c67b28c"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  # install metaphlan2_strainer (strainphlan) first which will install bowtie2
  # initial bowtie2 install will be used by humann2/kneaddata (instead of own installs)
  depends_on "biobakery/biobakery/strainphlan" => :recommended
  # install humann2 without metaphlan2 because metaphlan2_strainer (strainphlan) was installed
  depends_on "biobakery/biobakery/humann2" => [:recommended, "without-metaphlan2"]
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

