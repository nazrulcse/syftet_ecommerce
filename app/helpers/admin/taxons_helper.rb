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
        html += "<li> #{child.name}(#{taxon_path(child)}) #{taxon_actions(child)}"
        if child.children.any?
          html += "<ol> #{draw_taxon_tree(child)} </ol>"
        end
        html += '</li>'
      end
      html + '</ul>'
    end

    def taxon_actions(taxon)
      html = link_to raw("<i class='icon icon-plus'></i>"), new_admin_taxonomy_taxon_path(taxon.taxonomy_id, parent_id: taxon.id), title: 'Add child taxon', class: 'add'
      html += link_to raw("<i class='icon icon-edit'></i>"), edit_admin_taxonomy_taxon_path(taxon.taxonomy_id, taxon.id), title: 'Edit taxon', class: 'edit'
      html += (link_to raw("<i class='icon icon-delete'></i>"), admin_taxonomy_taxon_path(taxon.taxonomy_id, taxon.id), confirm: 'Are you sure?', class: 'delete', method: :delete, remote: true)
      "<span class='taxon-actions'> #{html} </span>"
    end
  end
end