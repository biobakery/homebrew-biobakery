class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "http://blast.ncbi.nlm.nih.gov/"
  url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.3.0+-src.tar.gz"
  version "2.3.0"
  sha256 "7ce8dc62f58141b6cdcd56b55ea3c17bea7a672e6256dfd725e6ef94825e94e9"

  def install
    cd "c++" do
      system "./configure", "--prefix=#{prefix}", "--libdir=#{libexec}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "blastn", "-version"
  end
end
