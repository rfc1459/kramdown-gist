# encoding: utf-8
#
# html.rb - gist-enabled HTML parser
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

require 'kramdown/parser/html'

module Kramdown
  module Parser

    class Html

      # Monkey-patch the standard Kramdown HTML post-processor so that all
      # references to embedded gists are replaced with a specialized `:gist` Element.
      class ElementConverter

        # This is the ugliest hack I *ever* wrote, believe me...
        # @private
        original_convert_script = instance_method(:convert_script)

        # @!method convert_script(el)
        #   Hook into the `<script>` tag conversion process so that we have a
        #   chance to generate `:gist` elements based on the `src` attribute
        #   of the tag.
        #   @api private
        define_method(:convert_script) do |el|
          if %r{^https?://gist.github.com/([0-9a-fA-F]+)\.js$} =~ el.attr['src']
            # We're in business, convert el to a gist element
            set_basics(el, :gist)
            el.value = $1
            el.children.clear
            el.attr.delete('src')
          else
            # Fall back to the original method
            original_convert_script.bind(self).call(el)
          end
        end

      end

    end

  end
end
