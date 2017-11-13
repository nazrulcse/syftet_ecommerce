module Admin
  module TaxonsHelper
    def taxon_path(taxon)
      #taxon.ancestors.reverse.collect { |ancestor| ancestor.name }.join(" >> ")
      link_to taxon.permalink, categories_path(taxon.permalink)
    end

    def draw_taxon_tree(node)
      html = "<div> #{node.name}(#{taxon_path(node)}) #{taxon_actions(node)} </div>"
      html += '<ul>'
      node.children.each do |child|
        if child.children.any?
          html += "#{draw_taxon_tree(child)}"
        else
          html += "<li> #{child.name}(#{taxon_path(child)}) #{taxon_actions(child)}"
          html += '</li>'
        end
      end
      html + '</ul>'
    end

    def taxon_actions(taxon)
      html = link_to raw("<i class='icon icon-plus'></i>"), new_admin_taxonomy_taxon_path(taxon.taxonomy_id, parent_id: taxon.id), title: 'Add child category', class: 'add'
      html += link_to raw("<i class='icon icon-edit'></i>"), edit_admin_taxonomy_taxon_path(taxon.taxonomy_id, taxon.id), title: 'Edit category', class: 'edit'
      html += (link_to raw("<i class='icon icon-delete'></i>"), admin_taxonomy_taxon_path(taxon.taxonomy_id, taxon.id), confirm: 'Are you sure?', class: 'delete', method: :delete, remote: true)
      "<span class='taxon-actions'> #{html} </span>"
    end

    def draw_category_tree(node, selected = '')
      html = "<li> #{link_to node.name, categories_path(node.permalink), class: (selected == node.id ? 'active' : '')}"
      html += "<span data-ref='top-#{node.id}' class='pull-right collapse-ref'> <i class='fa fa-plus'></i> </span>" if node.children.any?
      if node.children.any?
        html += "<ul id='top-#{node.id}'>"
        node.children.each do |child|
          if child.children.any?
            html += "#{draw_category_tree(child, selected)}"
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

  end
end