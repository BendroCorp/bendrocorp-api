class LiabilityController < ApplicationController
  before_action :require_user, except: [:list_hiring]
  before_action :require_member, except: [:list_hiring]
  before_action except: [] do |a|
    a.require_one_role([40])
  end

  def list
    # PointTransactions.all.group_by { |m| m.created_at.beginning_of_month }.
    # User.joins(:point_transactions).joins(:characters)
    # PointTransaction.all.group("user_id").sum('amount')
    # PointTransaction.all.joins(:user).group("users.username").sum('amount')
    # PointTransaction.all.joins(:user).joins(:characters).group("users.username").sum('amount')
    # PointTransaction.all.joins(:user => :characters).group("characters.first_name").sum('amount')
    # PointTransaction.all.joins(:user => :characters).group("CONCAT(characters.first_name, ' ', characters.last_name)").sum('amount')

    @points = PointTransaction.all.group("TO_CHAR(created_at, 'Month YYYY')").sum('amount')
    @total_liability = PointTransaction.all.sum(:amount)
    @total_uec_liability = @total_liability * 1000
    @liability_by_member = PointTransaction.all.joins(:user => :characters).group("CONCAT(characters.first_name, ' ', characters.last_name)").sum('amount')

    render status: 200, json: { points: @points, total_liability: @total_liability, total_uec_liability: @total_uec_liability, liability_by_member: @liability_by_member }
  end
end
