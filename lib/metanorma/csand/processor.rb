require "metanorma/processor"

module Metanorma
  module Csand
    class Processor < Metanorma::Processor

      def initialize
        @short = [:csand, :csa]
        @input_format = :asciidoc
        @asciidoctor_backend = :csand
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf"
        )
      end

      def version
        "Metanorma::Csand #{Metanorma::Csand::VERSION}"
      end

      def input_to_isodoc(file, filename)
        Metanorma::Input::Asciidoc.new.process(file, filename, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::Csand::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::Csand::WordConvert.new(options).convert(outname, isodoc_node)
        when :pdf
          IsoDoc::Csand::PdfConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
