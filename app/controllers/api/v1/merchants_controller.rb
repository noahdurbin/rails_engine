class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def search
    begin
      merchant = Merchant.search(params)
      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        render json: { data: {} }
      end
    rescue ArgumentError => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 400)).serialize_json, status: :bad_request
    end
  end

  def search_all
    begin
      merchants = Merchant.search_all(params)
      render json: MerchantSerializer.new(merchants)
    rescue ArgumentError => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 400)).serialize_json, status: :bad_request
    end
  end
end
