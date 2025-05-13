require 'nokogiri'

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output_ext == '.html'

  doc.output = add_first_letter_class(doc.output)
end

def add_first_letter_class(html)
  doc = Nokogiri::HTML.parse(html)  # changed from DocumentFragment.parse

  doc.css('h1, h2').each do |node|
    next if node.content.strip.empty?

    first_letter = node.content.strip[0]
    if node['class'] && !(node['class'].include?(first_letter))
      node['class'] = "#{node['class']} #{first_letter}".strip
    elsif node['class'].nil?
      node['class'] = first_letter
    end
  end

  doc.to_html  # this will now include the DOCTYPE
end
