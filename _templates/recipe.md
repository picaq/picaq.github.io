---
title: {{TITLE}}
permalink: {{PERMALINK}}
parent: {{PARENT}}
layout: recipe
nav_order: {{NAV_ORDER}}
date: {{DATE}}
# title_override:      # display-only H2 override, if the nav title should stay short
excerpt:               # markdown ok. Falls back to intro_blurb, then intro
description:           # only used when excerpt is absent — rendered invisibly
ingredients:
  -
# ingredients_blurb:   # markdown ok. Falls back to ingredients_intro
instructions:
  -
result_blurb:          # markdown ok
# nutrition gates the cuisine / diet / category / keywords block below.
# The keys below count as present even while blank, so that block renders
# either way — to suppress it, delete these four lines and leave `nutrition:` bare.
nutrition:
  calories:
  fatContent:
  carbohydrateContent:
  proteinContent:
prepmins:
cookmins:
yield:
image:
thumbnail:
tags: [featured, recipe]
cuisine:
diet:
category:
keywords:
---

{% render_recipe %}
