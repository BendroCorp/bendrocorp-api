class LawController < ApplicationController
    before_action :require_user
    before_action :require_member

    before_action except: [:fetch_laws_organized, :fetch_laws, :fetch_jurisdictions, :fetch_categories] do |a|
        a.require_one_role([43])
    end

    # GET /api/law/organized
    def fetch_laws_organized
        render status: 200, json: Jurisdiction.where(archived: false)
        .as_json(include: { categories: { include: { laws: {} } } })
    end

    # GET /api/law
    def fetch_laws
        render status: 200, json: JurisdictionLaw.where(archived: false).order('title')
    end
    
    # POST /api/law
    def create_law
        @law = JurisdictionLaw.new(law_params)
        @law.created_by = current_user
        if @law.save
            render status: 200, json: @law
        else
            render status: 500, json: { message: "Law could not be created because: #{@law.errors.full_messages.to_sentence}" }
        end
    end

    # PUT /api/law
    def update_law
        @law = JurisdictionLaw.find_by_id params[:law][:id].to_i
        if @law
            if @law.update_attributes(law_params)
                render status: 200, json: @law
            else
                render status: 500, json: { message: "Law could not be updated because: #{@law.errors.full_messages.to_sentence}" }
            end
        else
            render status: 404, json: { message: 'Law could not be found. It may have been removed.' }
        end
    end

    # DELETE /api/law/:law_id
    def archive_law
        @law = JurisdictionLaw.find_by_id params[:law_id].to_i
        if @law
            @law.archived = true
            if @law.save
                render status: 200, json: { message: 'Law archived!' }
            else
                render status: 500, json: { message: "Law could not be archived because: #{@law.errors.full_messages.to_sentence}" }
            end
        else
            render status: 404, json: { message: 'Law could not be found. It may have been removed.' }
        end
    end

    # GET /api/law/jurisdiction
    def fetch_jurisdictions
        render status: 200, json: Jurisdiction.where(archived: false).order('title')
    end

    # GET /api/law/jurisdiction/:jurisdiction_id
    def fetch_jurisdiction
        @jurisdiction = Jurisdiction.find_by_id(params[:jurisdiction_id])
        if @jurisdiction
            render status: 200, json: @jurisdiction.as_json(include: { categories: { include: { laws: {} } } })
        else
           render status: 404, json: { message: 'Jurisdiction not found!' }
        end
    end

    # POST /api/law/jurisdiction
    def create_jurisdiction
        @jurisdiction = Jurisdiction.new(jurisdiction_params)
        @jurisdiction.created_by = current_user
        if @jurisdiction.save
            render status: 200, json: @jurisdiction
        else
            render status: 500, json: { message: "Jurisdiction could not be created because: #{@jurisdiction.errors.full_messages.to_sentence}" }
        end
    end

    # PUT /api/law/jurisdiction
    def update_jurisdiction
        @jurisdiction = Jurisdiction.find_by_id params[:jurisdiction][:id].to_i
        if @jurisdiction
            if @jurisdiction.update_attributes(jurisdiction_params)
                render status: 200, json: @jurisdiction
            else
                render status: 500, json: { message: "Jurisdiction could not be updated because: #{@jurisdiction.errors.full_messages.to_sentence}" }
            end
        else
            render status: 404, json: { message: 'Jurisdiction could not be found. It may have been removed.' }
        end
    end

    # DELETE /api/law/jurisdiction/:jurisdiction_id
    def archive_jurisdiction
        @jurisdiction = Jurisdiction.find_by_id params[:jurisdiction_id].to_i
        if @jurisdiction
            @jurisdiction.archived = true
            if @jurisdiction.save
                render status: 200, json: @jurisdiction
            else
                render status: 500, json: { message: "Jurisdiction could not be updated because: #{@jurisdiction.errors.full_messages.to_sentence}" }
            end
        else
            render status: 404, json: { message: 'Jurisdiction could not be found. It may have been removed.' }
        end
    end

    # GET /api/law/category
    # GET /api/law/category/:jurisdiction_id
    def fetch_categories
        render status: 200, json: Jurisdiction.where(archived: false).order('ordinal').as_json(include: { laws: {} })
    end

    # POST /api/law/category
    def create_category
        @law_category = JurisdictionLawCategory.new(law_category_params)
        @law_category.created_by = current_user
        @law_category.ordinal = JurisdictionLawCategory.all.count + 1
        if @law_category.save
            render status: 200, json: @law_category
        else
            render status: 500, json: { message: "Law category could not be created because: #{@law_category.errors.full_messages.to_sentence}" }
        end
    end

    # PUT /api/law/category
    def update_category
        @law_category = JurisdictionLawCategory.find_by_id params[:category][:id].to_i
        if @law_category
            if @law_category.update_attributes(law_category_params)
                render status: 200, json: @law_category
            else
                render status: 500, json: { message: "Law category could not be updated because: #{@law_category.errors.full_messages.to_sentence}" }
            end
        else
            render status: 404, json: { message: 'Law category could not be found. It may have been removed.' }
        end
    end

    # DELETE /api/law/category/:category_id
    def archive_category
        @law_category = JurisdictionLawCategory.find_by_id params[:category_id].to_i
        if @law_category
            @law_category.archived = true
            if @law_category.save
                render status: 200, json: @law_category
            else
                render status: 500, json: { message: "Law category could not be archived because: #{@law_category.errors.full_messages.to_sentence}" }
            end
        else
            render status: 404, json: { message: 'Law category could not be found. It may have been removed.' }
        end
    end

    private
    def law_params
        params.require(:law).permit(:title, :law_category_id, :law_class, :jurisdiction_id)
    end

    private 
    def jurisdiction_params
        params.require(:jurisdiction).permit(:title)
    end

    private
    def law_category_params
        params.require(:category).permit(:title, :jurisdiction_id)
    end
end
