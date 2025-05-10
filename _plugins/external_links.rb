Jekyll::Hooks.register :documents, :post_render do |doc|
  if doc.output_ext == ".html"
    doc.output.gsub!(%r{<a\s+(?![^>]*target=)([^>]*href="https?://[^"]+")(.*?)>}, '<a \1 target="_blank" \2>')
  end
end

Jekyll::Hooks.register :pages, :post_render do |page|
  if page.output_ext == ".html"
    page.output.gsub!(%r{<a\s+(?![^>]*target=)([^>]*href="https?://[^"]+")(.*?)>}, '<a \1 target="_blank" \2>')
  end
end


Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output_ext == '.html'

  normalized_output = add_first_letter_class(doc.output)
  doc.output = normalized_output.unicode_normalize(:nfc)
end