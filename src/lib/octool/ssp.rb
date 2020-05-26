# frozen_string_literal: true

require 'erb'

module OCTool
    # Build DB, CSV, and markdown.
    class SSP
        def initialize(system, output_dir)
            @system = system
            @output_dir = output_dir
        end

        def pandoc
            @pandoc ||= begin
                # Load paru/pandoc late enough that help functions work
                # and early enough to be confident that we catch the correct error.
                require 'paru/pandoc'
                Paru::Pandoc.new
            end
        rescue UncaughtThrowError
            warn '[FAIL] octool requires pandoc to generate the SSP. Is pandoc installed?'
            exit(1)
        end

        def generate
            unless File.writable?(@output_dir)
                warn "[FAIL] #{@output_dir} is not writable"
                exit(1)
            end
            render_template
            write_acronyms
            write 'pdf'
            write 'docx'
        end

        def render_template
            print "Building markdown #{md_path} ... "
            template_path = File.join(ERB_DIR, 'ssp.erb')
            template = File.read(template_path)
            output = ERB.new(template, nil, '-').result(binding)
            File.open(md_path, 'w') { |f| f.puts output }
            puts 'done'
        end

        def write_acronyms
            return unless @system.acronyms

            out_path = File.join(@output_dir, 'acronyms.json')
            File.open(out_path, 'w') { |f| f.write JSON.pretty_generate(@system.acronyms) }
            ENV['PANDOC_ACRONYMS_ACRONYMS'] = out_path
        end

        # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        def write(type = 'pdf')
            out_path = File.join(@output_dir, "ssp.#{type}")
            print "Building #{out_path} ... "
            converter = pandoc.configure do
                from 'markdown'
                to type
                pdf_engine 'lualatex'
                toc
                toc_depth 3
                number_sections
                highlight_style 'pygments'
                filter 'pandoc-acronyms' if ENV['PANDOC_ACRONYMS_ACRONYMS']
                # https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings#Encoding_issue
                # Uncomment the following line after the "listings" package is compatible with utf8
                # listings
            end
            output = converter << File.read(md_path)
            File.new(out_path, 'wb').write(output)
            puts 'done'
        end
        # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

        def md_path
            @md_path ||= File.join(@output_dir, 'ssp.md')
        end
    end
end
