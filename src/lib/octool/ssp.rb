require 'erb'

module OCTool
    # Build DB, CSV, and markdown.
    class SSP
        def initialize(system, output_dir)
            @system = system
            @output_dir = output_dir
            render_template
            write
        end

        def render_template
            print "Building markdown #{md_path} ... "
            template_path = File.join(ERB_DIR, 'ssp.erb')
            template = File.read(template_path)
            output = ERB.new(template, nil, '-').result(binding)
            File.open(md_path, 'w') { |f| f.puts output }
            puts 'done'
        end

        def write
            print "Building #{pdf_path} ... "
            pandoc = Paru::Pandoc.new
            converter = pandoc.configure do
                from 'markdown'
                to 'pdf'
                pdf_engine 'lualatex'
                toc
                toc_depth 3
                number_sections
                highlight_style 'pygments'
            end
            output = converter << File.read(md_path)
            File.new(pdf_path, 'wb').write(output)
            puts 'done'
        end

        def md_path
            @md_path ||= File.join(@output_dir, 'ssp.md')
        end

        def pdf_path
            @pdf_path ||= File.join(@output_dir, 'ssp.pdf')
        end
    end
end
