class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def search
    if params[:name].present?
      merchant = Merchant.search(params[:name])

      if merchant.nil?
        render json: ErrorSerializer.new(ErrorMessage.new("Record Not Found", 404)).serialize_json, status: 404
      else
       render json: MerchantSerializer.new(merchant), status: 200
      end
    else
      render json: ErrorSerializer.new(ErrorMessage.new("Name Must Be Filled In", 400)).serialize_json, status: 400
    end
  end
end
