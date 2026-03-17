class Base < Formula
  desc "Internal SwiftUI app scaffolder"
  homepage "https://github.com/minhvblc/BaseProject"
  url "git@github.com:minhvblc/BaseProject.git",
      tag:      "0.1.0",
      revision: "da86b70a3d46a02f4ca3947f3c85fa6ed2ebbfa9"
  version "0.1.0"
  license :cannot_represent

  depends_on "xcodegen"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "base", "--package-path", "base-cli"
    bin.install "base-cli/.build/release/base"

    template_root = share/"base-cli/template"
    template_root.mkpath
    FileUtils.cp_r(
      Dir["base-template/{*,.*}"].reject { |path| [".", ".."].include?(File.basename(path)) },
      template_root
    )
  end

  def caveats
    <<~EOS
      Optional:
        brew install swiftlint
    EOS
  end

  test do
    output_path = testpath/"SmokeApp"
    system bin/"base", "new",
      "--app-name", "Smoke App",
      "--target-name", "SmokeApp",
      "--bundle-id", "com.example.smokeapp",
      "--output", output_path,
      "--skip-generate",
      "--no-input"

    assert_path_exists output_path/"project.yml"
    assert_match "name: SmokeApp", (output_path/"project.yml").read
  end
end
