class Audiobook < Formula
  desc "Turn a book you own into an expressive audiobook, cloud or fully local"
  homepage "https://github.com/olostan/expressive-audiobook"
  url "https://github.com/olostan/expressive-audiobook/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b8a1d10da60ebd4b48bc44ae61afa703ff76333a811a56f234c788c3dac23565"
  license "Apache-2.0"

  depends_on "ffmpeg"
  depends_on "uv"

  # Homebrew builds without network access and PyMuPDF cannot be built from source offline,
  # so this installs a launcher. uv fetches and caches the app and its Python packages on first run.
  def install
    (bin/"audiobook").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("uv")}/uvx" --quiet --python ">=3.11" --from "#{stable.url}" audiobook "$@"
    SH
  end

  def caveats
    <<~EOS
      The first run downloads the app's Python packages (about a minute).
      Add a Gemini key to a .env file in the folder you work in, or run fully local
      with Ollama + Orpheus. Check your setup with:
        audiobook doctor
    EOS
  end

  test do
    assert_match "audiobook", shell_output("#{bin}/audiobook --version")
  end
end
