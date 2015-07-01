class AsJsonListStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:build_list).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).as_json
  end
end

FactoryGirl.register_strategy(:as_json, AsJsonListStrategy)
