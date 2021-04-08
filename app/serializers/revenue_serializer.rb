class RevenueSerializer
  class << self
    def revenue_range(revenue)
        #  { "data": { 
        #           "id": "null",
        #           "type": "string",
        #           "attributes": { 
        #               "type": "revenue",
        #               "properties": {
        #                   "revenue": revenue,
        #               },
        #           }
        #   }
        # }
      # { properties: 
      #   {data: 
      #     {type: "revenue",
      #       properties: { id: 'null',
      #         type: { type: "string"},
      #         attributes: { type: "revenue",
      #           properties: { revenue: revenue}
      # }}}}}
      # require 'pry'; binding.pry
      { data: { id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        } } }
    end
  end
end
