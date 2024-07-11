class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    render json: ItemSerializer.new(Item.update!(params[:id], item_params)), status: 200
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy

    render json: ItemSerializer.new(item), status: 204
  end

  def merchant
    @item = Item.find(params[:item_id])
    render json: MerchantSerializer.new(@item.merchant), status: 200
  end

  private

  def item_params
    params.require(:item).permit(:name, :unit_price, :description, :merchant_id)
  end
end
