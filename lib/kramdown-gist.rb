# encoding: utf-8
#
# kramdown-gist.rb - kramdown extension for gist tags
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

require 'kramdown-gist/version'

require 'kramdown'
require 'kramdown/parser/kramdown'
require 'kramdown/parser/kramdown/block_boundary'

module Kramdown
  module Parser

    # Gist-enabled Kramdown parser.
    class KramdownGist < Kramdown

     # Create a new gist-enabled Kramdown parser with the given +options+.
     def initialize(source, options)
        super
        @block_parsers.unshift(:gist)
      end

      # @private
      GIST_START = /^#{OPT_SPACE}\*\{gist:(\h+?)\}\n/

      # @private
      def parse_gist
        @src.pos += @src.matched_size
        gist_id = @src[1]
        @tree.children << Element.new(:raw,
          "<script src=\"http://gist.github.com/#{gist_id}.js\"></script>",
          nil, { :category => :block })
      end
      define_parser(:gist, GIST_START)

    end

  end
end
