class PolymarketTui < Formula
  desc "Terminal client for Polymarket prediction markets"
  homepage "https://github.com/byronxlg/polymarket-tui"
  url "https://files.pythonhosted.org/packages/94/5b/bc8e26bfb0ca9f97b2d54fcf3432244f6567f0fc0140d56979816fedfc92/polymarket_tui-0.1.0.tar.gz"
  sha256 "2818c5000a09cf1aacccc9b6155ab8ed400f05219a71f38d0aea8120a4d853fc"
  license "MIT"
  head "https://github.com/byronxlg/polymarket-tui.git", branch: "main"

  depends_on "python@3.12"

  def install
    python = formula_opt_bin("python@3.12")/"python3.12"
    system python, "-m", "venv", libexec
    # Personal tap: dependencies resolve from PyPI at install time rather than
    # being vendored as homebrew-core-style resource blocks. The stable url
    # tracks the published PyPI release; `brew install --HEAD` tracks main.
    system libexec/"bin/pip", "install", "--quiet", "--upgrade", "pip"
    system libexec/"bin/pip", "install", "--quiet", buildpath.to_s
    bin.install_symlink libexec/"bin/polymarket-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polymarket-tui --version")
  end
end
