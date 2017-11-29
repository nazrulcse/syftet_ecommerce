module TaxonsHelper
  # Retrieves the collection of products to display when "previewing" a taxon.  This is abstracted into a helper so
  # that we can use configurations as well as make it easier for end users to override this determination.  One idea is
  # to show the most popular products for a particular taxon (that is an exercise left to the developer.)
  def taxon_preview(taxon, max=4)
    products = taxon.active_products.select("spree_products.*, spree_products_taxons.position").limit(max)
    if (products.size < max)
      products_arel = Product.arel_table
      taxon.descendants.each do |taxon|
        to_get = max - products.length
        products += taxon.active_products.select("spree_products.*, spree_products_taxons.position").
            where(products_arel[:id].not_in(products.map(&:id))).limit(to_get)
        break if products.size >= max
      end
    end
    products
  end

  def draw_menu_tree(node, selected = '')
    html = "<li> #{link_to node.name, categories_path(node.permalink), class: (selected == node.id ? 'active' : '')}"
    html += "<span data-ref='top-#{node.id}' class='pull-right collapse-ref'> <i class='fa fa-plus'></i> </span>" if node.children.any?
    if node.children.any?
      html += "<ul id='top-#{node.id}'>"
      node.children.each do |child|
        if child.children.any?
          html += "#{draw_menu_tree(child, selected)}"
        else
          html += "<li> #{link_to child.name, categories_path(child.permalink), class: (selected == child.id ? 'active' : '')}"
          html += "<span data-ref='top-#{child.id}' class='pull-right collapse-ref'> <i class='fa fa-plus'></i> </span>" if child.children.any?
          html += '</li>'
        end
      end
      html += '</ul>'
    end
    html + '</li>'
  end

  def draw_nav_menu_tree(node)
    html = "<li> #{link_to node.name, categories_path(node.permalink)}"
    html += "<span data-ref='top-#{node.id}' class='pull-right tri-label-collapse'> <i class='fa fa-angle-right'></i> </span>" if node.children.any?
    if node.children.any?
      html += "<ul id='top-#{node.id}'>"
      node.children.each do |child|
        if child.children.any?
          html += "#{draw_nav_menu_tree(child)}"
        else
          html += "<li> #{link_to child.name, categories_path(child.permalink)}"
          html += "<span data-ref='top-#{child.id}' class='pull-right collapse-ref'> <i class='fa fa-angle-right'></i> </span>" if child.children.any?
          html += '</li>'
        end
      end
      html += '</ul>'
    end
    html + '</li>'
  end

  def draw_mobile_menu_tree(node)
    html = "<li class='dropdown-submenu'> #{link_to raw("#{node.name} #{node.children.any? ? "<b class='caret'> </b>" : '' }"), categories_path(node.permalink)}"
    # html += "<span data-ref='top-#{node.id}' class='pull-right tri-label-collapse'> <i class='fa fa-angle-right'></i> </span>" if node.children.any?
    if node.children.any?
      html += "<ul class='dropdown-menu'>"
      node.children.each do |child|
        if child.children.any?
          html += "#{draw_mobile_menu_tree(child)}"
        else
          html += "<li class='dropdown-submenu'> #{link_to raw("#{child.name} #{child.children.any? ? "<b class='caret'> </b>" : '' }"), categories_path(child.permalink)}"
          # html += "<span data-ref='top-#{child.id}' class='pull-right collapse-ref'> <i class='fa fa-angle-right'></i> </span>" if child.children.any?
          html += '</li>'
        end
      end
      html += '</ul>'
    end
    html + '</li>'
  end

  def active_taxons(taxonomy = nil)
    if taxonomy
      top_taxons = taxonomy.taxons
    else
      top_taxons = Taxon.joins(:taxonomy)
    end
    top_taxons.where('taxons.parent_id IS NULL')
  end
end