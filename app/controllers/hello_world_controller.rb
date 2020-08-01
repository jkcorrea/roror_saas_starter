# frozen_string_literal: true

class HelloWorldController < ApplicationController
  before_action :skip_authorization

  def show
    @hello_world_props = { name: "Stranger" }
  end
end
