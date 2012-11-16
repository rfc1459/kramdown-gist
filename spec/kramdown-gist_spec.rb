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
  it "converts a valid public gist tag to a script tag" do
    ::Kramdown::Document.new("*{gist:1234}\n", :input => 'KramdownGist').to_html.should eql("<script src=\"http://gist.github.com/1234.js\"></script>\n")
  end

  it "converts a valid private gist tag to a script tag" do
    ::Kramdown::Document.new("*{gist:deadbeef}", :input => 'KramdownGist').to_html.should eql("<script src=\"http://gist.github.com/deadbeef.js\"></script>\n")
  end

  it "falls back to default behaviour on malformed tag" do
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
