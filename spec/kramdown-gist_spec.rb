# encoding: utf-8
#
# kramdown-gist_spec.rb - kramdown-gist RSpec tests
# Copyright (C) 2012 Matteo Panella <morpheus@level28.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'kramdown-gist'

describe Kramdown::Parser::KramdownGist do
  context "when parsing a simple block" do
    it "converts a valid public gist tag to a script tag" do
      ::Kramdown::Document.new("*{gist:1234}\n", :input => 'KramdownGist').to_html.should eql("<script src=\"https://gist.github.com/1234.js\"></script>\n")
    end

    it "converts a valid private gist tag to a script tag" do
      ::Kramdown::Document.new("*{gist:deadbeef}", :input => 'KramdownGist').to_html.should eql("<script src=\"https://gist.github.com/deadbeef.js\"></script>\n")
    end

    it "falls back to default behaviour when the tag is malformed" do
      ::Kramdown::Document.new("*{gist:antani}", :input => 'KramdownGist').to_html.should eql("<p>*{gist:antani}</p>\n")
    end

    it "does not treat the gist tag as a span-level element" do
      ::Kramdown::Document.new("testing 123 *{gist:1234}", :input => 'KramdownGist').to_html.should eql("<p>testing 123 *{gist:1234}</p>\n")
      ::Kramdown::Document.new("testing 123\n*{gist:1234}", :input => 'KramdownGist').to_html.should eql("<p>testing 123\n*{gist:1234}</p>\n")
    end

    it "is idempotent when generating kramdown" do
      ::Kramdown::Document.new("*{gist:1234}", :input => 'KramdownGist').to_kramdown.should eql("*{gist:1234}\n\n")
    end

    it "renders to a suitable placeholder when generating LaTeX" do
      ::Kramdown::Document.new("*{gist:1234}", :input => 'KramdownGist').to_latex.should eql("See \\href{https://gist.github.com/1234}{Gist 1234}.\n\n")
    end
  end

  context "when parsing a complex document" do
    # Standard kramdown source and rendered files
    let(:standard_src)    { IO.read(File.expand_path("../fixtures/standard.md", __FILE__)) }
    let(:standard_html)   { IO.read(File.expand_path("../fixtures/standard.html", __FILE__)) }
    let(:standard_latex)  { IO.read(File.expand_path("../fixtures/standard.tex", __FILE__)) }

    # KramdownGist source and rendered files
    let(:gist_src)    { IO.read(File.expand_path("../fixtures/gist.md", __FILE__)) }
    let(:gist_html)   { IO.read(File.expand_path("../fixtures/gist.html", __FILE__)) }
    let(:gist_latex)  { IO.read(File.expand_path("../fixtures/gist.tex", __FILE__)) }

    context "without gist tags" do
      it "produces valid HTML output" do
        ::Kramdown::Document.new(standard_src, :input => 'KramdownGist').to_html.should eql(standard_html)
      end

      it "produces valid LaTeX output" do
        ::Kramdown::Document.new(standard_src, :input => 'KramdownGist').to_latex.should eql(standard_latex)
      end
    end

    context "with gist tags" do
      it "produces valid HTML output" do
        ::Kramdown::Document.new(gist_src, :input => 'KramdownGist').to_html.should eql(gist_html)
      end

      it "produces valid LaTeX output" do
        ::Kramdown::Document.new(gist_src, :input => 'KramdownGist').to_latex.should eql(gist_latex)
      end
    end
  end
end

describe Kramdown::Parser::Html do
  context "when parsing a simple script tag" do
    let(:jquery)      { '<script src="http://code.jquery.com/jquery.min.js"></script>' }
    let(:mathjax_src) { '<script type="math/tex; mode=display">1</script>' }
    let(:mathjax_out) { "$$1$$\n\n" }

    it "should convert embedded gists to gist tags" do
      ::Kramdown::Document.new('<script src="https://gist.github.com/42.js"></script>', :input => 'html').to_kramdown.should eql("*{gist:42}\n\n")
    end

    it "should leave non-gist script tags as they are" do
      ::Kramdown::Document.new(jquery, :input => 'html').to_kramdown.should eql("#{jquery}\n\n")
    end

    it "should convert MathJax script tags to LaTeX math blocks" do
      ::Kramdown::Document.new(mathjax_src, :input => 'html').to_kramdown.should eql(mathjax_out)
    end
  end
end
