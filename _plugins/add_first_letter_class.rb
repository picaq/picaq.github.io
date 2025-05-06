require 'nokogiri'

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output_ext == '.html'

  doc.output = add_first_letter_class(doc.output)
end

def add_first_letter_class(html)
  doc = Nokogiri::HTML::DocumentFragment.parse(html)

  doc.css('h1, h2').each do |node|
    next if node.content.strip.empty?

    first_letter = node.content.strip[0]
    node['class'] = "#{node['class']} #{first_letter}".strip
  end

  doc.to_html
end
