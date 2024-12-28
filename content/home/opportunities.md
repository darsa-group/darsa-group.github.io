---
# An instance of the Portfolio widget.
# Documentation: https://wowchemy.com/docs/page-builder/
widget: portfolio

# This file represents a page section.
headless: true

# Order that this section appears on the page.
weight: 120

title: Opportunities
subtitle: ''

content:
  # Page type to display. E.g. project.
  page_type: opportunities
  sort_by: Params.weight
  # Default filter index (e.g. 0 corresponds to the first `filter_button` instance below).
  filter_default: 0

  # Filter toolbar (optional).
  # Add or remove as many filters (`filter_button` instances) as you like.
  # To show all items, set `tag` to "*".
  # To filter by a specific tag, set `tag` to an existing tag name.
  # To remove the toolbar, delete the entire `filter_button` block.
  filter_button:
    - name: All
      tag: '*'
    - name: Postdoc
      tag: postdoc
    - name: PhD Student
      tag: phd
    - name: Master Student
      tag: masters
    - name: Undergraduate
      tag: undergrad
      
design:
  # Choose how many columns the section has. Valid values: '1' or '2'.
  columns: '2'

  # Toggle between the various page layout types.
  #   1 = List
  #   2 = Compact
  #   3 = Card
  #   5 = Showcase
  view: 2

  # For Showcase view, flip alternate rows?
  flip_alt_rows: false
---
If you have project ideas and are motivated, we list below a number of options 
to obtain funding and we would be happy discuss and possibly support you. [Send us a CV and describe your interest](#contact).
