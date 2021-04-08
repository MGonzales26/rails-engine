class RevenueSerializer
  class << self
    def revenue_range(revenue)
      { data: { id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        } } }
    end
  end
end
