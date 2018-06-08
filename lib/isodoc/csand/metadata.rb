require "isodoc"

module IsoDoc
  module Csand
    # A {Converter} implementation that generates CSAND output, and a document
    # schema encapsulation of the document for validation
    class Metadata < IsoDoc::Metadata
            def initialize(lang, script, labels)
        super
        set(:status, "XXX")
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//title[@language='en']"))&.text
        set(:doctitle, main)
      end

      def subtitle(_isoxml, _out)
        nil
      end

      def author(isoxml, _out)
        set(:tc, "XXXX")
        tc = isoxml.at(ns("//editorialgroup/committee"))
        set(:tc, tc.text) if tc
      end


      def docid(isoxml, _out)
        docnumber = isoxml.at(ns("//bibdata/docidentifier"))
        docstatus = isoxml.at(ns("//bibdata/status"))
        dn = docnumber&.text
        if docstatus
          set(:status, status_print(docstatus.text))
          abbr = status_abbr(docstatus.text)
          dn = "#{dn}(#{abbr})" unless abbr.empty?
        end
        set(:docnumber, dn)
      end

      def status_print(status)
        status.split(/-/).map{ |w| w.capitalize }.join(" ")
      end

      def status_abbr(status)
        case status
        when "working-draft" then "wd"
        when "committee-draft" then "cd"
        when "draft-standard" then "d"
        else
          ""
        end
      end
    end
  end
end
