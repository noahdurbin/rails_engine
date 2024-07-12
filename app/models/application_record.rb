class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.search(params)
    if params[:name].present? && (params[:max_price].present? || params[:min_price].present?)
      raise ArgumentError, 'Cannot search by both name and price'
    elsif params[:name].present?
      search_by_name(params[:name]).first
    elsif params[:max_price].present? || params[:min_price].present?
      search_by_price(params).first
    else
      raise ArgumentError, 'No valid search parameters provided'
    end
  end

  def self.search_all(params)
    if params[:name].present? && (params[:max_price].present? || params[:min_price].present?)
      raise ArgumentError, 'Cannot search by both name and price'
    elsif params[:name].present?
      search_by_name(params[:name])
    elsif params[:max_price].present? || params[:min_price].present?
      search_by_price(params)
    else
      raise ArgumentError, 'No valid search parameters provided'
    end
  end

  private

  def self.search_by_name(name)
    where("name ILIKE ?", "%#{name}%").order(Arel.sql("LOWER(name)"))
  end

  def self.search_by_price(params)
    min_price = params[:min_price].to_f
    max_price = params[:max_price].to_f

    if min_price.negative? || max_price.negative?
      raise ArgumentError, "Prices must be greater than or equal to 0"
    elsif max_price.positive? && min_price >= max_price
      raise ArgumentError, "Max price cannot be lower than or equal to min price"
    end

    items = Item.all
    items = items.where("unit_price >= ?", min_price) if params[:min_price].present?
    items = items.where("unit_price <= ?", max_price) if params[:max_price].present?
    items.order(Arel.sql("LOWER(name)"))
  end
end
