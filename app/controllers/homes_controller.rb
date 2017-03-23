class HomesController < ApplicationController

  def index
    @recipes = Recipe.all
  end

end
