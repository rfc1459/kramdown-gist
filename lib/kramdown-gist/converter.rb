# encoding: utf-8
#
# converter.rb - monkey-patches for Kramdown converters
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

module Kramdown
  module Converter

    class Html

      # Convert a gist element into a `<script>` tag suitable for embedding.
      #
      # @return [String] an HTML fragment representing this element
      # @api private
      def convert_gist(el, indent)
        "#{' '*indent}<script src=\"https://gist.github.com/#{el.value}.js\"></script>\n"
      end

    end

    class Kramdown

      # Convert a gist element into the equivalent Kramdown "tag"
      #
      # @return [String] an Kramdown fragment representing this element
      # @api private
      def convert_gist(el, opts)
        "*{gist:#{el.value}}\n"
      end

    end

    class Latex

      # Convert a gist element into a LaTeX paragraph stating the Gist ID and
      # including the target hyperlink as metadata suitable for some output
      # formats (PDF).
      #
      # @return [String] a LaTeX fragment representing this element
      # @api private
      def convert_gist(el, opts)
        gist_id = el.value
        "See \\href{https://gist.github.com/#{gist_id}}{Gist #{gist_id}}.\n\n"
      end

    end

  end
end
