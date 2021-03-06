module Admin
  class TaxonsController < Admin::BaseController

    before_action :load_taxonomy, only: [:create, :edit, :update, :new]
    before_action :load_taxon, only: [:edit, :update]
    respond_to :html, :json, :js

    def index

    end

    # def search
    #   if params[:ids]
    #     @taxons = Taxon.where(id: params[:ids].split(','))
    #   else
    #     @taxons = Taxon.limit(20).ransack(name_cont: params[:q]).result
    #   end
    # end

    def create
      @taxon = @taxonomy.taxons.build(taxon_params)
      if @taxon.save!
        respond_with(@taxon) do |format|
          format.json { render json: @taxon.to_json }
          format.html { redirect_to edit_admin_taxonomy_taxon_path(@taxonomy.id, @taxon.id) }
        end
      else
        flash[:error] = Spree.t('errors.messages.could_not_create_taxon')
        respond_with(@taxon) do |format|
          format.html { redirect_to @taxonomy ? edit_admin_taxonomy_url(@taxonomy) : admin_taxonomies_url }
        end
      end
    end

    def new
      @taxon = @taxonomy.taxons.build(parent_id: params[:parent_id])
    end

    def edit
      @permalink_part = @taxon.permalink.split("/").last
    end

    def update
      parent_id = params[:taxon][:parent_id]
      set_position
      set_parent(parent_id) if parent_id

      @taxon.save!

      # regenerate permalink
      regenerate_permalink if parent_id

      set_permalink_params

      #check if we need to rename child taxons if parent name or permalink changes
      @update_children = true if params[:taxon][:name] != @taxon.name || params[:taxon][:permalink] != @taxon.permalink

      if @taxon.update_attributes(taxon_params)
        flash[:success] = flash_message_for(@taxon, :successfully_updated)
      end

      #rename child taxons
      rename_child_taxons if @update_children

      respond_with(@taxon) do |format|
        format.html { redirect_to edit_admin_taxonomy_url(@taxonomy) }
        format.json { render json: @taxon.to_json }
      end
    end

    def destroy
      @taxon = Taxon.find(params[:id])
      @taxon.destroy
      respond_with(@taxon) { |format|
        format.json { render json: '' }
        format.js {}
      }
    end

    def search
      taxons = Taxon.joins(:taxonomy)
      if params[:ids]
        taxons = taxons.where(id: params[:ids].split(','))
      end
      if params[:q].present? && params[:q][:name_cont].present?
        taxons = taxons.where("lower(taxons.name) like '%#{params[:q][:name_cont].downcase}%'")
      end
      respond_to do |format|
        format.json { render json: {taxons: taxons.collect { |taxon| {text: taxon.name, id: taxon.id} }} }
      end
    end

    private

    def taxon_params
      params.require(:taxon).permit!
    end

    def load_taxon
      @taxon = @taxonomy.taxons.find(params[:id])
    end

    def load_taxonomy
      @taxonomy = Taxonomy.find(params[:taxonomy_id])
    end

    def set_position
      new_position = params[:taxon][:position]
      if new_position
        @taxon.child_index = new_position.to_i
      end
    end

    def set_parent(parent_id)
      if parent_id.present?
        @taxon.parent = Taxon.find(parent_id.to_i)
      end
    end

    def set_permalink_params
      if params.key? "permalink_part"
        parent_permalink = @taxon.permalink.split("/")[0...-1].join("/")
        parent_permalink += "/" unless parent_permalink.blank?
        params[:taxon][:permalink] = parent_permalink + params[:permalink_part]
      end
    end

    def rename_child_taxons
      @taxon.descendants.each do |taxon|
        reload_taxon_and_set_permalink(taxon)
      end
    end

    def regenerate_permalink
      reload_taxon_and_set_permalink(@taxon)
      @update_children = true
    end

    def reload_taxon_and_set_permalink(taxon)
      taxon.reload
      taxon.set_permalink
      taxon.save!
    end
  end
end