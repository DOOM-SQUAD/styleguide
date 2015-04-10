# Styleguide

The Styleguide gem is intended to provide a living internal styleguide to any application with default guidelines
which are easily customizable within the application. It offers [KSS](https://github.com/kneath/kss) support for stylesheet
parsing as well as support for Markdown templates (for `md`, `mdown`, and `markdown` file extensions) and the `:markdown` Haml
filter. Additionally, it implements [Pygments.rb](https://github.com/tmm1/pygments.rb) syntax highlighting for colorizing code blocks.

## Installation

Styleguide is distributed as a gem, which is how it should be used in your app.

Include the gem in your Gemfile:

```ruby
gem "styleguide", "~> 0.0", :git => "git@github.com/doom-squad/styleguide.git"
```

## Quick Start

Styleguide is written as a mountable [Rails engine](http://edgeguides.rubyonrails.org/engines.html) and comes preconfigured with its own
routes. To mount the engine in your application's `config/routes.rb`:

```ruby
mount Styleguide::Engine, at: 'styleguide', as: 'styleguide'
```

## Usage

Styleguide content is broken down by two categories: *section* and *reference*. The *section* is used to separate content by language or platform
(e.g. Ruby, CSS, Javascript, etc.) while the *reference* is used to organize content within a particular section (e.g. Constants,
Strings, Regular Expresions, etc.). Generally, references are numeric and resemble a semantic version number such as `1.0`. However, a
reference can actually be anything matching `/(\d+\.\d+)|(\w+)/`.

All styleguide requests are routed through a single controller and action, namely `'sections#show'`. By default, the *show* template will render
three files: a sections menu partial, a references menu partial, and a template located at `styleguide/'#{styleguide_section}/#{styleguide_reference}'` that
contains content for the selected section and reference.

For example, a request to `http://example.com/styleguide/ruby/1.0` would look for a partial with the path
`styleguide/sections/ruby/1.0.html.erb`. The template extension can obviously be anything supported by your application, including
`md`, `mdown`, and `markdown` which is supported through this gem.

### Helpers

Styleguide comes with several helpers to aid in authoring your guideline content:

  * `styleguide_section` - Contains the currently requested section.
  * `styleguide_reference` - Contains the currently requested reference.
  * `markdown` - Renders a markdown string into HTML.
  * `highlight_syntax` - Renders a string into Pygments styleable HTML. The second argument can supply the lexer.
  * `styleguide_link_to` - Both `:section` and `:reference` can be passed in the second argument. A class of `selected` will be added to the link
      if it points to the current section or reference (within the current section).
  * `kss_block` - Create a stylesheet example block containing description, modifiers, live examples, and example HTML.

### Sections

Because routes are rendered dynamically, any section/reference that has a matching template will be rendered. However, the engine comes with a
default sections menu that has 5 built-in sections: Overview, CSS, JavaScript, Ruby, and Mobile.

To override this default sections menu, create a partial with the path `styleguide/shared/_sections.html.erb`. If you're using the
default styles, the partial should have a `ul` containing the section links nested under `nav.sections`.

A section link can easily be generated with the `Styleguide::SectionsHelper`:

```ruby
styleguide_link_to 'CSS', section: 'css'
```

See the [default sections menu](https://github.com/doom-squad/styleguide/blob/master/app/views/styleguide/shared/_sections.html.haml) for more clarification.

### References

To provide a references menu for a given section, create a partial with the path `styleguide/#{styleguide_section}/_references.html.erb`.
If you're using the default styles, the partial should have a `ul` containing the references links nested under `nav.references`.

A reference link can easily be generated with the `Styleguide::SectionsHelper`:

```ruby
styleguide_link_to 'Buttons', reference: 1.0
```

See the [default ruby references menu](https://github.com/doom-squad/styleguide/blob/master/app/views/styleguide/sections/ruby/_references.html.haml) for more clarification.

## KSS

[KSS](https://github.com/kneath/kss) is a gem written by GitHub meant to provide a method of writing maintainable documentation similar
to [TomDoc](http://tomdoc.org/). To read more about how to use KSS, please read [their documentation](https://github.com/kneath/kss).

### Configuration

To setup KSS to parse your application's stylesheets, you will need to create an initializer and set up the `stylesheet_paths` variable.
This variable is an array similar to `config.assets.load_paths` and can contain multiple stylesheet path strings. Each path in the array
will be parsed by KSS.

Add the following to `config/initializers/styleguide.rb` and configure as needed:

```ruby
Styleguide.setup do |config|
  config.stylesheet_paths << File.expand_path('app/assets/stylesheets', Rails.root)
end
```

### References

KSS references should be organized in a numerical hierarchy similar to semantic versioning. Additionally, a third number may be used for even more precision.

For example, if **Buttons** are designated as section `1.0`, then the default buttons may be `1.1`, mini-buttons `1.2`, and mini-buttons with icons `1.2.1`.

See the [GitHub styleguide](https://github.com/styleguide/css/1.0) for an example hierarchy.

### Usage

Once stylesheets have been documented with KSS comment blocks, examples can be created using the `KSS::Parser` and `kss_block` helper method. The `kss_block` helper method
takes one argument for the section (e.g. '1.1' or '1.2.1') and a ruby block containing example HTML. Within the example HTML, all occurrences of `$modifier_class`
will be replaced with the modifier class when generating live examples.

For example,

```sass
// Typical button element setup with class `btn`.
//
// .lite - Light colored button.
// .go - A "go" button.
// .archive - Use when element has been archived.
//
// Styleguide 1.1
```

```erb
<%= kss_block('1.1') do %>
  <a class="btn $modifier_class" href="#">Click Here</a>
<% end %>
```

will create an example block containing the description (with Markdown), a list of modifiers and their descriptions, live example of the base button, live
examples for each of the modifying classes, and a syntax-highlighted block containing the example HTML.

To override the default kss block HTML, create a view with the path `styleguide/shared/_kss_block.html.erb`.

See the [default kss partial](https://github.com/doom-squad/styleguide/blob/master/app/views/styleguide/shared/_kss_block.html.haml) for more clarification.

## Overrides

The Styleguide gem comes with a collection of default guidelines for CSS, JavaScript, and Ruby. Any of these can be overridden by creating a template
with the same path as the template in the gem (including the `_references` partials).

### Controller

There may be a case where you need to override one of the default controllers - perhaps to use a custom layout or mount the styleguide behind your application's
authentication mechanisms. To do so, you will need to create a controller with the same name and path as the controller you are overriding.

You will also need to bring in the `Engine.helpers` unless you are overriding all of the views as well and do not plan on using any of the helper methods.

For example, to override the `Styleguide::SectionsController`, you would create a file with the path of `styleguide/sections_controller.rb`.

```ruby
class Styleguide::SectionsController < ::ApplicationController
  helper Styleguide::Engine.helpers
end
```

Similarly, if you had another `ApplicationController` containing your authentication logic, you could simply extend that class instead to hide the styleguide
behind your authentication structure.

```ruby
class Styleguide::SectionsController < ::Admin::ApplicationController
  helper Styleguide::Engine.helpers
end
```

### Layout

There are a couple of ways to override the built-in layout. If you simply wanted to override the default layout completely, you could just create a new layout
with a path of `layouts/styleguide/application.html.erb`. **Note:** be sure to include a stylesheet link to `styleguide/application` if you want to
use the default styles.

However, if you wanted to extend the layout, you will need to first override a controller and set the layout to your new layout template.

```ruby
class Styleguide::SectionsController < ::ApplicationController
  helper Styleguide::Engine.helpers
  layout 'styleguide'
end
```

When extending a layout, you can make use of the built-in `content_for` sections that are in the default layout: `stylesheets`, `header`, `footer`, and `javascripts`.

For example, to add in your own stylesheet to the default layout, you could add a `stylesheet_link_tag` to the `stylesheets` section then simply render the default layout.

```erb
<% content_for :stylesheets do %>
  <%= stylesheet_link_tag "application", media: "screen" %>
<% end %>

<%= render template: 'layouts/styleguide/application' %>
```

The `header` and `footer` sections are directly above and below the rendered view template respectively.

### Styles

By default, each styleguide page is wrapped with an `<article class="styleguide">` that also contains the `styleguide_section` and `styleguide_reference`
in the classname. This can be used to add specific styles to certain sections or pages.

For example, the styleguide overview page has custom styles to display a large image and headline text welcoming the user. This was achieved by adding styles
to `.styleguide.overview.index`.
