require "kramdown"

module Jekyll
  class RenderRecipeTag < Liquid::Tag
    
    # def strip_html(input)
    #   input.gsub(/<\/?[^>]*>/, '')
    # end

    def markdown_to_html(markdown_input)
      markdown = <<~MD
        #{markdown_input}
      MD
      Kramdown::Document.new(markdown, input: "GFM").to_html
    end
    
    def render(context)
      page = context['page']
      site = context['site']
      content = context['content']

      # You can access any page variable here
      title = page['title']
      image = page['image']
      excerpt = page['excerpt'] || page['intro_blurb'] || page['intro']
      description = page['description']
      prepmins = page['prepmins']
      cookmins = page['cookmins']
      recipe_yield = page['yield']
      ingredients = page['ingredients'] || []
      instructions = page['instructions'] || []
      result_blurb = page['result_blurb']
      nutrition = page['nutrition'] || {}

      # You can manually build the HTML string
      output = <<~HTML
        <h2 id="#{title.downcase.strip.gsub(' ', '-')}" itemprop="name">
          <a href="##{title.downcase.strip.gsub(' ', '-')}" class="anchor-heading" aria-labelledby="#{title.downcase.strip.gsub(' ', '-')}"><svg viewBox="0 0 16 16" aria-hidden="true"><use xlink:href="#svg-link"></use></svg></a>
          #{title}
        </h2>
        <img src="#{image}" alt="#{title}" itemprop="image" class="recipe-image">
      HTML

      if excerpt
        output << "<div itemprop=\"description\">#{markdown_to_html(excerpt)}</div>"
      else 
        output << "<p itemprop=\"description\" class=\"invisible\">#{description}</p>"
      end

      if prepmins || cookmins || recipe_yield
        output << "<dl class=\"dl-horizontal\">"
        output << "<dt>Preparation time</dt><dd>#{prepmins} min#{'s' if prepmins != 1}<span itemprop=\"prepTime\" class=\"invisible\">PT#{prepmins}M</span></dd>" if prepmins
        output << "<dt>Cooking time</dt><dd>#{cookmins} min#{'s' if cookmins != 1}<span itemprop=\"cookTime\" class=\"invisible\">PT#{cookmins}M</span></dd>" if cookmins
        output << "<dt>Yield</dt><dd>#{recipe_yield} serving#{'s' if recipe_yield != 1} <span itemprop=\"recipeYield\" class=\"invisible\">#{recipe_yield}</span></dd>" if recipe_yield
        output << "</dl>"
      end

      output << "<h3 id=\"ingredients\"><a href=\"#ingredients\" class=\"anchor-heading\" aria-labelledby=\"ingredients\"><svg viewBox=\"0 0 16 16\" aria-hidden=\"true\"><use xlink:href=\"#svg-link\"></use></svg></a> Ingredients</h3>"
      output << "<ul>"
      ingredients.each do |ingredient|
        output << "<li itemprop=\"recipeIngredient\">#{ingredient}</li>"
      end
      output << "</ul>"

      output << "<h3 id=\"instructions\"><a href=\"#instructions\" class=\"anchor-heading\" aria-labelledby=\"instructions\"><svg viewBox=\"0 0 16 16\" aria-hidden=\"true\"><use xlink:href=\"#svg-link\"></use></svg></a> Instructions</h3>"
      output << "<ol itemprop=\"recipeInstructions\">"
      instructions.each do |step|
        output << "<li>#{step}</li>"
      end
      output << "</ol>"

      if result_blurb
        output << "<div>#{markdown_to_html(result_blurb)}</div>"
      end

      if nutrition.any?
        output << "<h3 id=\"nutrition-facts\"><a href=\"#nutrition-facts\" class=\"anchor-heading\" aria-labelledby=\"nutrition-facts\"><svg viewBox=\"0 0 16 16\" aria-hidden=\"true\"><use xlink:href=\"#svg-link\"></use></svg></a> Nutrition Facts</h3>"
        output << "<p><em>in grams per serving</em></p>"
        output << "<dl itemprop=\"nutrition\" itemscope itemtype=\"https://schema.org/NutritionInformation\">"
        output << "<dt>Calories</dt><dd itemprop=\"calories\">#{nutrition['calories']}</dd>"
        output << "<dt>Fat</dt><dd itemprop=\"fatContent\">#{nutrition['fatContent']}</dd>"
        output << "<dt>Carbohydrates</dt><dd itemprop=\"carbohydrateContent\">#{nutrition['carbohydrateContent']}</dd>"
        output << "<dt>Protein</dt><dd itemprop=\"proteinContent\">#{nutrition['proteinContent']}</dd>"
        output << "</dl>"

        output << "<div itemscope itemprop=\"author\" itemtype=\"http://schema.org/Person\" class=\"invisible\">"
        output << "<span itemprop=\"name\">#{site['title']}</span>"
        output << "<span itemprop=\"url\">https://picaq.github.io</span>"
        output << "</div>"

        output << "<dl>"

        output << "<dt>cuisine</dt><dd itemprop=\"recipeCuisine\">#{page['cuisine']}</dd>" if page['cuisine']
        output << "<dt>diet</dt><dd>#{page['diet']}</dd>" if page['diet']
        output << "<dt>category</dt><dd itemprop=\"recipeCategory\">#{page['category']}</dd>" if page['category']

        if page['keywords']
          keywords = page['keywords'].is_a?(Array) ? page['keywords'].join(', ') : page['keywords']
          output << "<dt>keywords</dt><dd itemprop=\"keywords\">#{keywords}</dd>"
        end

        output << "</dl>"
      end

      output
    end
  end
end

Liquid::Template.register_tag('render_recipe', Jekyll::RenderRecipeTag)
