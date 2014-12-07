class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @partner_types = PartnerType.all.order('name')
    respond_with(@partners)
  end

  def new
    @types = PartnerType.all.order('name')
  end

  def edit
    @types = PartnerType.all.order('name')
  end

  def destroy
    Partner.find(params['id']).destroy
    redirect_to partners_path
  end

  def edit_partner
    type = params['type']
    case type
    when 'new'
      partner_type = PartnerType.new
      partner_type.name = params['new_type']
      partner_type.save
    else
      partner_type = PartnerType.find(type)
    end
    partner = Partner.find(params['partner_id'])
    partner.name = params['partner_name']
    partner.phone = params['phone']
    partner.address = params['address']
    partner.url = params['website']
    partner.comment = params['comments']
    partner.save
    partner_type.partners << partner
    redirect_to partners_path
  end

  def new_partner
    type = params['type']
    case type
    when 'new'
      partner_type = PartnerType.new
      partner_type.name = params['new_type']
      partner_type.save
    else
      partner_type = PartnerType.find(type)
    end
    partner = Partner.new
    partner.name = params['partner_name']
    partner.phone = params['phone']
    partner.address = params['address']
    partner.url = params['website']
    partner.comment = params['comments']
    partner.save
    partner_type.partners << partner
    redirect_to partners_path
  end

  def category
    respond_to do |format|
      format.html { render partial: 'partners/partner_list', locals: { partners: PartnerType.find(params['id']).partners.order('name') } }
    end
  end

  private
    def set_partner
      @partner = Partner.find(params[:id])
    end

    def partner_params
      params.require(:partner).permit(:type, :name, :phone, :address, :url, :comment, :img)
    end
end
